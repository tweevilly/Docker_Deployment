# 6. Deploying the application to Azure

My plan for taking the published image and running it in the cloud with **Azure Container Apps**. This was the written part of Task C: explain the deployment, not necessarily perform it.

## Overview

```text
Docker Hub (public image) ──▶ Azure Container App ──▶ public HTTPS/HTTP URL, port 8080
```

## Steps

### 1. Create an Azure account and sign in
Sign up for a Microsoft Azure account, then sign in to the **Azure Portal**.

### 2. Prepare the image
Make sure the Spring Boot application is containerized and **pushed to Docker Hub as a public image**. A public image means Azure can pull it without any authentication setup, which avoids a common source of deployment errors.

### 3. Create a Container App resource
1. In the portal, choose **Create a resource**.
2. Search the marketplace for **Container App** and click **Create**. This runs the app as a managed container service, so there are no servers to look after.
3. Create a new **resource group** so everything related to this app is organized, and can be removed, together.

### 4. Fill out the form and deploy
- **Basics:** enter a unique Container App name and pick a region. The other settings can stay at their defaults.
- **Image settings:** set the image source to **Docker Hub**, choose **Public**, and enter the image name and tag, e.g. `<dockerhub-user>/d387_<student-id>`.
- **Ingress and networking:** enable ingress, allow traffic from anywhere, select **HTTP**, allow insecure connections, and set the **target port to 8080**, the port the Spring Boot app listens on.
- Review the settings and click **Create**.

### 5. Verify
Azure opens the Container App resource page and shows the deployment status. Once it finishes, open the resource's **Application Url** and confirm the Landon Hotel application loads.

## Why the earlier lessons matter here

- The **target port (8080)** in the ingress settings has to match what the app actually listens on. That is why the Dockerfile exposes 8080, and why reading the port from an environment variable keeps the app portable across platforms.
- A **single image** that contains both the back end and the compiled front end means there's only one thing to deploy and one port to configure.
- This setup is fine for a course demo. For a real application I would use HTTPS only (not "allow insecure connections") and avoid the file-based H2 database.
