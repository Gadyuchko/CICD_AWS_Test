# CICD_GitHub_AWS_EC2_SingleContainer
### The project is a template for a CICD pipeline from GitHub SpringBoot project to AWS EC2 deployment. 
#### Consists of stages:
* (Optionall) merge action with master branch protection rule
* Repository push action as a trigger which activates registered webhook to start pipeline first <b>Source</b> stage  
which is provided by GitHub WebHook registered by us (from AWS pipeline) with repository,  
at this stage source code is downloaded to Artifact Store bucket on S3 by pipeline.
* Second stage is a <b>jar executable build</b> stage which is provided by CodeBuild project we created for pipeline.  
Intructions for the stage is in ```jarbuildspec.yaml``` at this stage we can check for compilation errors,  
unit test the application, any sort of intermidiate testing. Testing and building is provided by maven plugin we provided for  
Springboot appliction, the final maven command ```mvn package``` produces executable jar file,  
and out CodeBuild is instructed to export this jar file together with other artifacts needed for next stage to Artifact store bucket.
* Next stage is a <b> Docker image build</b> stage provided by another CodeBuild project we created for pipeline.  
Instructions for the stage are in ```dockerbuildspec.yaml``` at this stage we are building docker image  by using Dockerfile  
and pushing it to Elastic Container Registry we provided for pipeline. Finally CodeBuild is exporting artifacts  
needed for the next stage of our pipeline to Artifact Store bucket.
* Final stage of this pipeline is <b>Docker container deploy</b> to AWS EC2, stage is provided by CodeDeploy deployment group  
containing our EC2 instance and CodeDeploy Application, (optionally we can provide CodeDeploy Deployment Configuration resource  
for more complex deployments, but for this example & simplicity sake it is not included).  
At this stage CodeDeploy uses instruction from ```appspec.yml``` which includes 3 hooks which includes bash scripts  
to stop container (if running), docker login to ECR, and start container. Final hook includes commands for docker-compose  
to pull image and start container. These commands will be using ```docker-compose.yaml``` file as instructions set, for port mapping,  
naming, and aws logging driver with automatic logGroup creation option to push application logs to CloudWatch

### Project Architecture

![CICD Pepeline GITHUB - AWS SpringBoot Docker Container App (3)](https://github.com/Gadyuchko/CICD_GitHub_AWS_EC2_SingleContainer/assets/51369173/b4d50715-f3a6-464f-8143-05a3a8d8ec37)

### Resource provisioning
Project leverages Infrastructure as Code (IaC) supplied by CloudFormation. All resources are created in CloudFormation stacks:
* VPC stack resources in ```vpc.template.yaml``` supplied for 2 separate environments, simple dev environment with single AZ public and private subnets,  
and prod environment for dual AZ subnets (please note that for ALB 2AZ assosiation is nessesary), also choice between NATGW and NAT instances provided in template
* Infrastructure stack resources including EC2 instances for Bastion Host and Application instance,  
Application Load Balancer with Target Group and HTTP Listener on port 80 Security Groups and Instance Profile,  
IAM Roles for resources are declared in ```dev.infrastructure.for.pipeline.template.yaml```
* And pipeline stack resources provided by ```github.toec2.pipeline.yaml``` which includes CodeBuild & CodeDeploy resources together with Roles and Storage,  
there is additional pipeline template  ```github.toec2.branchmerge.pipeline.yaml``` which includes optional CodeBuild stage  
with merge webhook specially for master branch protection rule, it can be used to force check pass for this stage  
to protect merge action to master branch by issuing branch rule and including webhook check in it, usefull if you are working in multibranch environment.

### Final notes
EC2 instance must be set up to include Docker, docker-compose plugin, codedeploy agent installed on it,  
template includes EC2 UserData script to install these on bootstrap. I wasn't able to 'win' over ```AWS::CloudFormation::Init```  
for some reason signal is not sent from cfn-signal helper scrip for me, so if you know the solution to include these bootstrap action in Metadata  
using ```AWS::CloudFormation::Init``` and helpper scripts in user data you are welcome to contribute .
