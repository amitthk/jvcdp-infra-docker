import java.text.SimpleDateFormat

testEnvUrl = 'http://localhost:8089/'

node {
currentBuild.result = "SUCCESS"
  try{
   def mvnHome;
   def project_id;
   def artifact_id;
   def aws_s3_bucket_name;
   def aws_s3_bucket_region;
   def timeStamp;
   def userInput = false;
   def didTimeout = false;
   stage('Initalize'){
	   aws_s3_bucket_name = 'jvcdp-repo';
	   aws_s3_bucket_region = 'us-east-1';
	   timeStamp = getTimeStamp();
   }
   stage('Checkout') { // for display purposes
      // Get some code from a GitHub repository
      checkout scm;
   }
   stage('installprerequisites'){
       run_playbook('configureserver.yaml')
   }
    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY_ID', credentialsId: 'aws-deployuser', secretKeyVariable: 'AWS_SECRET_ACCESS_KEY']])  
    {
        stage('Download Artifacts'){
        userInput = false;
	didTimeout = false;
	
	try {
	    timeout(time: 15, unit: 'MINUTES') { // change to a convenient timeout for you
	        userInput = input(message: 'Should I redownload latest artifacts?', ok: 'Yes', 
                        parameters: [booleanParam(defaultValue: true, 
                        description: 'If you would want to re-download latest artifacts, just push the button',name: 'Yes?')])
	    }
	} catch(err) { // timeout reached or input false
	    def user = err.getCauses()[0].getUser()
	    if('SYSTEM' == user.toString()) { // SYSTEM means timeout.
	        didTimeout = true
	    } else {
	        userInput = false
	        echo "Aborted by: [${user}]"
	    }
	}
        if ((didTimeout)||(!userInput)) {
            // do something on timeout
            echo "no input was received before timeout"
            currentBuild.result = 'ABORTED'
        } else {
        run_playbook('downloadartifacts.yaml')
        }
        }
    }
   stage('Build Images'){

    userInput = false;
	didTimeout = false;
	
	try {
	    timeout(time: 15, unit: 'MINUTES') { // change to a convenient timeout for you
	        userInput = input(message: 'Should build Images?', ok: 'Yes', 
                        parameters: [booleanParam(defaultValue: true, 
                        description: 'If you would want to build images, just push the button',name: 'Yes?')])
	    }
	} catch(err) { // timeout reached or input false
	    def user = err.getCauses()[0].getUser()
	    if('SYSTEM' == user.toString()) { // SYSTEM means timeout.
	        didTimeout = true
	    } else {
	        userInput = false
	        echo "Aborted by: [${user}]"
	    }
	}
        if ((didTimeout)||(!userInput)) {
            // do something on timeout
            echo "no input was received before timeout"
            currentBuild.result = 'ABORTED'
        } else {
            run_playbook('buildimages.yaml')
        } 
   }
   stage('Run Containers'){
       userInput = false;
	didTimeout = false;
	
	try {
	    timeout(time: 2, unit: 'DAYS') { // change to a convenient timeout for you
	        userInput = input(message: 'Should I run the containers?', ok: 'Yes', 
                        parameters: [booleanParam(defaultValue: true, 
                        description: 'If you would want to run the containers now, just push the button',name: 'Yes?')])
	    }
	} catch(err) { // timeout reached or input false
	    def user = err.getCauses()[0].getUser()
	    if('SYSTEM' == user.toString()) { // SYSTEM means timeout.
	        didTimeout = true
	    } else {
	        userInput = false
	        echo "Aborted by: [${user}]"
	    }
	}
        if ((didTimeout)||(!userInput)) {
            // do something on timeout
            echo "no input was received before timeout"
            currentBuild.result = 'ABORTED'
        } else {
       run_playbook('runcontainers.yaml')
        }
   }
   stage('Recreate Network'){
       run_playbook('recreate_network.yaml')
   }
  }catch (err) {

        currentBuild.result = "FAILURE"

        throw err
    }
}

def getTimeStamp(){
	def dateFormat = new SimpleDateFormat("yyyyMMddHHmm")
	def date = new Date()
	return dateFormat.format(date);
}

def version() {
    def ver = readFile('pom.xml') =~ '<version>(.+)</version>'
    ver ? ver[0][1] : null
    def art = readFile('pom.xml') =~ '<artifactId>(.+)</artifactId>'
    art ? art[0][1] : null
    def pck = readFile('pom.xml') =~ '<packaging>(.+)</packaging>'
    pck ? pck[0][1] : null
	version = art+ver ? art + '-' + ver + '.' + pck : artifactId + '.jar'
	return version;
}

def mvn(args) {
    _mvnHome = tool 'Maven3.5.0'
    sh "${_mvnHome}/bin/mvn ${args}"
}

def runTests(duration) {
    node {
        checkout scm
        runWithServer {url ->
            mvn "-o -f sometests test -Durl=${url} -Dduration=${duration}"
        }
    }
}

def run_playbook(id) {
	sh "cd ansible && ansible-playbook ${id}";
}

def stop_container(container_name) {
    sh "docker stop ${container_name}"
}

def runWithServer(body) {
    def id = UUID.randomUUID().toString()
    deploy id
    try {
        body.call "${jettyUrl}${id}/"
    } finally {
        undeploy id
    }
}
