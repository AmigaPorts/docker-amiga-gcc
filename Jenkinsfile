def notify(status){
	emailext (
		body: '$DEFAULT_CONTENT',
		recipientProviders: [
			[$class: 'CulpritsRecipientProvider'],
			[$class: 'DevelopersRecipientProvider'],
			[$class: 'RequesterRecipientProvider']
		],
		replyTo: '$DEFAULT_REPLYTO',
		subject: '$DEFAULT_SUBJECT',
		to: '$DEFAULT_RECIPIENTS'
	)
}

@NonCPS
def killall_jobs() {
	def jobname = env.JOB_NAME
	def buildnum = env.BUILD_NUMBER.toInteger()
	def killnums = ""
	def job = Jenkins.instance.getItemByFullName(jobname)
	def fixed_job_name = env.JOB_NAME.replace('%2F','/')

	for (build in job.builds) {
		if (!build.isBuilding()) { continue; }
		if (buildnum == build.getNumber().toInteger()) { continue; println "equals" }
		if (buildnum < build.getNumber().toInteger()) { continue; println "newer" }

		echo "Kill task = ${build}"

		killnums += "#" + build.getNumber().toInteger() + ", "

		build.doStop();
	}

	if (killnums != "") {
		slackSend color: "danger", channel: "#jenkins", message: "Killing task(s) ${fixed_job_name} ${killnums} in favor of #${buildnum}, ignore following failed builds for ${killnums}"
	}
	echo "Done killing"
}

def buildStep(DOCKER_ROOT, DOCKERIMAGE, DOCKERTAG, DOCKERFILE, BUILD_NEXT) {
	def fixed_job_name = env.JOB_NAME.replace('%2F','/')
	try {
		checkout scm;

		def buildenv = '';
		def tag = '';
		if (env.BRANCH_NAME.equals('master')) {
			buildenv = 'production';
			tag = "${DOCKERTAG}";
		} else if (env.BRANCH_NAME.equals('dev')) {
			buildenv = 'development';
			tag = "${DOCKERTAG}-dev";
		} else {
			throw new Exception("Invalid branch, stopping build!");
		}

		docker.withRegistry("https://index.docker.io/v1/", "dockerhub") {
			def customImage
			stage("Building ${DOCKERIMAGE}:${tag}...") {
				customImage = docker.build("${DOCKER_ROOT}/${DOCKERIMAGE}:${tag}", "--build-arg BUILDENV=${buildenv} --network=host --pull -f ${DOCKERFILE} .");
			}

			stage("Pushing to docker hub registry...") {
				customImage.push();
			}
		}

		if (!BUILD_NEXT.equals('')) {
			build "${BUILD_NEXT}/${env.BRANCH_NAME}";
		}
	} catch(err) {
		slackSend color: "danger", channel: "#jenkins", message: "Build Failed: ${fixed_job_name} #${env.BUILD_NUMBER} Target: ${DOCKER_ROOT}/${DOCKERIMAGE}:${tag} (<${env.BUILD_URL}|Open>)"
		currentBuild.result = 'FAILURE'
		notify("Build Failed: ${fixed_job_name} #${env.BUILD_NUMBER} Target: ${DOCKER_ROOT}/${DOCKERIMAGE}:${tag}")
		throw err
	}
}

node('master') {
	killall_jobs();
	def fixed_job_name = env.JOB_NAME.replace('%2F','/');
	slackSend color: "good", channel: "#jenkins", message: "Build Started: ${fixed_job_name} #${env.BUILD_NUMBER} (<${env.BUILD_URL}|Open>)";
	
	checkout scm;

	def branches = [:]
	def project = readJSON file: "JenkinsEnv.json";

	project.builds.each { v ->
		branches["Build ${v.DockerRoot}/${v.DockerImage}:${v.DockerTag}"] = { 
			node {
				buildStep(v.DockerRoot, v.DockerImage, v.DockerTag, v.Dockerfile, v.BuildIfSuccessful)
			}
		}
	}
	
	sh "rm -rf ./*"

	parallel branches;
}

