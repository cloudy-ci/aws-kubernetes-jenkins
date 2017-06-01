# aws-kubernetes-jenkins
Simple Example Playbook

## Set up a Kubernetes Cluster on AWS

First, you need an AWS Account with credentials. Check that this is set up correctly by running
```
aws iam get-user
```

Then, there are several scripts to help get you started quickly.


The first script in the series downloads recent versions kubectl, kops and helm into the current directory:
```
source 01-install.sh  # Downloads kubectl, kops and helm and sets the PATH to the current directory
```

The second scripts just creates a subdomain for an existing domain you own and manage via AWS.
```
./02-aws-create-subdomain.sh k8s-subdomain.example.com
```
In case you manage your domains elsewhere, you need to do this step manually.


The third script creates a management S3 bucket for kops. By convention we name it the same as the k8s domain
```
source 03-aws-create-s3-bucket.sh k8s-subdomain.example.com  # Sets KOPS\_STATE\_STORE
```

Next, we use kops to start a small cluster:
```
./04-kops-create-cluster.sh k8s-subdomain.example.com
```

Now we have to wait for a bit. We can use that time to get familiar with the kops command, maybe look at:
```
kops help
kops get cluster
kops validate cluster
# ...
```

## Set up the Dashboard and Jenkins on the Kubernetes Cluster

When `kops validate cluster` returns, we can deploy the dashboard to our brand-new kubernetes cluster:
```
./05-kubernetes-start-dashboard.sh
```

Then we initialize helm and install the Jenkins package with the kubernetes-plugin preinstalled!
```
./06-helm-init.sh
```
This command prints instructions on how to connect to the Jenkins server on kubernetes.

## Setting up Jenkins on Kubernetes

When you are logged in to Jenkins, you can create Jobs, for example a 'Github Organization' Job pointing at cloudy-ci.
Provide any github credentials to circumvent the strict rate limiting which is otherwise in place.

This should now automatically pull and execute the Jenkinsfile from the cloudy-ci/jenkinspipelines repo, and run them
for every branch. Have fun!

## Job DSL Seed Job

In the jenkinspipelines repo, there is an init.groovy at top level:
https://github.com/cloudy-ci/jenkinspipelines/blob/master/init.groovy

This is a JobDSL seed job. To install the JobDSL plugin, you can now either modify the jenkins-chart-values.yaml and
destroy and recreate the Jenkins deployment, or quickly install it via the Jenkins interface. You can then set up a
"freestyle job" pointing at the jenkinspipelines repository, activate the JobDSL plugin build step and point it at the
init.groovy file.

## Further Topics

If you want to keep your automatically created Jobs up to date, you can also run the JobDSL plugin from the Jenkinsfile
on every run of the master branch. This obviates the need for a Seed Job!

For real usage you probably want to set up an LetsEncrypt Ingress for Kubernetes, so that your connection to the Jenkins
system is protected by HTTPS.
