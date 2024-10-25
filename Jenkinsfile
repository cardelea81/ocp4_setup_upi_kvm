pipeline {
   agent any

   stages {
      stage('Clone Git Repository') {
         steps {
            git(
               url: "https://github.com/cardelea81/ocp4_setup_upi_kvm.git",
               branch: "main",
               changelog: true,
               poll: true
          )
         }
      }
      stage('Build') {
         steps {
            echo 'Building new OCP cluster'
            sshagent(['production']) {
                sh "ssh  -t -o StrictHostKeyChecking=no -l hudson ocp.lab.dev.example.com 'sudo /hudson/ocp4_setup_upi_kvm/jm/cluster-storage-build.sh'"
          }
         }
      }
   }
}

