The scripts on this page are under construction. 

upskilling in kubernetes in-progress.

As of 27/06/2022, I have full filled my destiny in deploying EKS using Terraform with a result to deploy a NGINX image to a load balancer, node cluster. 

What I gained in this experience? 
* Understand the architecture and the process of Kubernetes
* AWS required permissions to deploy: 
    * node cluster
    * eks cluster
    * autoscalling group
    * eks worker group
    * launch template
* All of the above, using Terraform. 

More details will show on here, as I am excited to give you little more insight to how you can start your own way and deploy a simple EKS cluster and deploy your application on Kubernetes. 

Feedback: 
* I wish I could deploy my yaml script directly from the terminal. However, this was the challenge I couldn't understand and I will try looking for the answers I am looking for and improve. 
* The kubernetes cluster was deployed from .tf script. would be nicer to deploy, with kubectl deploy -f filename.yaml instead. 