1) Multi branch pipeline

The Multibranch Pipeline project type enables you to implement different Jenkinsfiles for different branches of the same project. In a Multibranch Pipeline project, Jenkins automatically discovers, manages and executes Pipelines for branches which contain a Jenkinsfile in source control.

2) Forgot password, how would you login
```sh
/var/lib/jenkins/config.xml
```

3) Jenkins can store the following types of credentials:

  Secret text - a token such as an API token (e.g. a GitHub personal access token) i.e copy the secret text and paste it into the Secret field.

  Username and password - which could be handled as separate components or as a colon separated string in the format username:password (read more about this in Handling credentials), i.e specify the credential’s Username and Password in their respective fields.

  Secret file - which is essentially secret content in a file,

  SSH Username with private key - an SSH public/private key pair,

  Certificate - a PKCS#12 certificate file and optional password, or

  Docker Host Certificate Authentication credentials.

4) Using for loop in Declarative file:
#Script Block in Declarative Pipeline

```sh
pipeline {
    agent any
    stages {
        stage('Example') {
            steps {
                echo 'Hello World'

                script {
                    def browsers = ['chrome', 'firefox']
                    for (int i = 0; i < browsers.size(); ++i) {
                        echo "Testing the ${browsers[i]} browser"
                    }
                }
            }
        }
    }
}
```

5) Syntax to run parallel stages in declarative pipeline:

```sh
pipeline {
    agent none
    stages {
        stage('Run Tests') {
            parallel {
                stage('Test On Windows') {
                    agent {
                        label "windows"
                    }
                    steps {
                        bat "run-tests.bat"
                    }
                    post {
                        always {
                            junit "**/TEST-*.xml"
                        }
                    }
                }
                stage('Test On Linux') {
                    agent {
                        label "linux"
                    }
                    steps {
                        sh "run-tests.sh"
                    }
                    post {
                        always {
                            junit "**/TEST-*.xml"
                        }
                    }
                }
            }
        }
    }
}
```

Is there a way to ignore failure?



Sonar:

What is quality gates and quality profile?

Quality Profiles are a core component of SonarQube where you define sets of Rules that, when violated, raise issues on your codebase (example: Methods should not have a Cognitive Complexity higher than 15). Each individual language has its own Quality Profile.


With the Quality Gate, you can enforce ratings (reliability, security, security review, and maintainability) based on metrics on overall code and new code. These metrics are part of the default quality gate. 

Replay vs Rebuild: 

Rebuild, using the Rebuilder plugin allows a completed job to be re-executed while allowing you to change the parameters, assuming your job is parameterized.

Replay does something similar, except it doesn't show you parameters. Instead, it shows the pipeline code directly. This is helpful when wanting to test changes iteratively as you can click Replay, change one or two lines of code, then let it execute. The job will run using the same parameters as it did the first time it ran/completed.
