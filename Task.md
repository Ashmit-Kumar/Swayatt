# ***DevOps Task***
1. **Objective**

Set up a simple CI/CD pipeline for a sample application using AWS/GCP, Jenkins, and GitHub. The pipeline should demonstrate automation, scalability, and best DevOps practices.

1. **Task Details**
    
    a. Source Code & Version Control (GitHub)
    
    * Fork/clone a sample Node.js (https://github.com/SwayattDrishtigochar/devops-task).
    
    * Push code to a GitHub repository with a clear branching strategy (main, dev).
    
    b. CI/CD Pipeline (Jenkins)
    
    * Create a Jenkins pipeline with GitHub webhook trigger. 
    
    * Pipeline stages should include:
    
    - Build: Install dependencies & run tests.
    
    - Dockerize: Build Docker image.
    
    - Push to Registry: Push image to DockerHub / AWS ECR / GCP Artifact Registry.
    
    - Deploy: Deploy container to AWS ECS / GCP Cloud Run / Kubernetes (EKS/GKE).
    
    c. Infrastructure (Cloud – AWS or GCP)
    
    * Use either AWS or GCP for deployment.
    
    * Must use at least one of:
    
    - AWS ECS / EKS / EC2
    
    - GCP GKE / Cloud Run
    
    * Bonus: Use Terraform or CloudFormation for IaC.
    
    d. Monitoring & Logging
    
    * Configure basic monitoring/logging with CloudWatch (AWS) / Stackdriver (GCP).
    
    * Document how logs/metrics can be viewed.
    
    e. Documentation
    
    * Provide a README.md with:
    
    - Architecture diagram.
    
    - Setup instructions.
    
    - Explanation of pipeline flow.
    

1. **Evaluation Criteria**
    - Proper use of GitHub branching & commits.
    - Working Jenkins pipeline with automation.
    - Quality of Dockerfile & containerization best practices.
    - Cloud deployment correctness & simplicity.
    - Bonus: Infrastructure as Code implementation.
    - Clarity & completeness of documentation.

1. **Submission Criteria**
- Submission link:  https://forms.gle/otmnfQvxiBh4YLW1A
- Submit Before midnight of 14th September 2025 (Sunday)

1. **Candidates must submit a single GitHub repository link containing:**
    
    a. Source & Config Files
    
    * Application code.
    
    * Dockerfile.
    
    * Jenkinsfile (pipeline definition).
    
    * Terraform/CloudFormation files (if used).
    
    * README.md with setup & deployment guide.
    
    b. Deployment Proof (inside repo as folder deployment-proof/):
    
    * Public URL of the deployed application (preferred).
    
    * OR Screenshots of successful deployment & Jenkins pipeline stages.
    
    c. Architecture Diagram
    
    * Added inside README.md or included in repo (/docs/architecture.png or .pdf).
    
    d. Short Write-up
    
    * A markdown file (WRITEUP.md) or included in README.md with:
    
    * Tools & services used.
    
    * Challenges faced & how you solved them.
    
    * Possible improvements if given more time.