pipeline {
  agent { 
    dockerfile {
      reuseNode true
    }
  }
  
  stages {
    stage('Build') {
      steps {
        sh 'rm -rf _posts'
        sh 'git clone https://github.com/gideao/articles.git _posts'
        sh 'jekyll build'
      }
    }

    stage('Deploy') {
      environment { 
        AWS_ACCESS_KEY_ID = credentials('aws-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-access-key')
      }

      steps {
        sh 'aws s3 sync _site s3://www.gideao.co --delete --acl public-read'
      }
    }
  }
}
