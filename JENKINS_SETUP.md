# Jenkins Setup Guide for TalentFlow

This guide will help you install Jenkins and configure the CI/CD pipeline for the TalentFlow project.

## 📋 Prerequisites

- Windows 10/11 (or Linux/Mac)
- Java JDK 11 or higher
- Node.js 18+ installed
- Docker Desktop installed and running
- Git installed

## 🚀 Installing Jenkins

### Option 1: Windows (Recommended)

1. **Download Jenkins:**
   - Visit https://www.jenkins.io/download/
   - Download the Windows installer (jenkins.msi)

2. **Install Jenkins:**
   - Run the installer
   - Follow the installation wizard
   - Jenkins will start automatically as a Windows service

3. **Initial Setup:**
   - Open browser to `http://localhost:8080`
   - Find the initial admin password in:
     - `C:\Program Files\Jenkins\secrets\initialAdminPassword`
   - Copy and paste the password
   - Install suggested plugins
   - Create your admin user account

### Option 2: Docker (Alternative)

```bash
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts
```

Access Jenkins at `http://localhost:8080` and follow the setup wizard.

## 🔧 Configuring Jenkins for TalentFlow

### 1. Install Required Plugins

Go to **Manage Jenkins → Manage Plugins → Available** and install:

- **Pipeline** (usually pre-installed)
- **Docker Pipeline** (for Docker integration)
- **Git** (for Git integration)
- **NodeJS Plugin** (for Node.js builds)
- **AnsiColor** (for colored console output)
- **Timestamper** (for build timestamps)

Click **Install without restart** and wait for installation.

### 2. Configure Node.js

1. Go to **Manage Jenkins → Global Tool Configuration**
2. Scroll to **NodeJS**
3. Click **Add NodeJS**
4. Configure:
   - **Name:** `NodeJS-18` (or your preferred name)
   - **Version:** Select Node.js 18.x or higher
   - **Global npm packages to install:** (leave empty)
5. Click **Save**

### 3. Configure Docker

1. Ensure Docker Desktop is running
2. In Jenkins, go to **Manage Jenkins → Manage Nodes and Clouds**
3. Configure Docker if needed (usually works out of the box on Windows with Docker Desktop)

### 4. Add Docker Hub Credentials (Optional - for pushing images)

1. Go to **Manage Jenkins → Manage Credentials**
2. Click **System → Global credentials → Add Credentials**
3. Configure:
   - **Kind:** Username with password
   - **Username:** Your Docker Hub username
   - **Password:** Your Docker Hub password/token
   - **ID:** `dockerhub-creds` (must match Jenkinsfile)
   - **Description:** Docker Hub credentials
4. Click **OK**

## 📦 Creating the Pipeline Job

### Method 1: Pipeline from SCM (Recommended)

1. **Create New Item:**
   - Click **New Item** on Jenkins dashboard
   - Enter name: `TalentFlow-CI-CD`
   - Select **Pipeline**
   - Click **OK**

2. **Configure Pipeline:**
   - Scroll to **Pipeline** section
   - **Definition:** Pipeline script from SCM
   - **SCM:** Git
   - **Repository URL:** `https://github.com/PathaSnehith/devopsproject5.git`
   - **Credentials:** (add if private repo)
   - **Branches to build:** `*/submission` (or your branch name)
   - **Script Path:** `talentflow/Jenkinsfile`
   - Click **Save**

3. **Run the Pipeline:**
   - Click **Build with Parameters**
   - Adjust parameters if needed:
     - **IMAGE_NAME:** `your-docker-username/talentflow`
     - **PUSH_IMAGE:** `true` (if you want to push to registry)
     - **AUTO_DEPLOY:** `false` (unless you have deployment configured)
   - Click **Build**

### Method 2: Copy Jenkinsfile Content

1. **Create New Item:**
   - Click **New Item**
   - Name: `TalentFlow-CI-CD`
   - Select **Pipeline**
   - Click **OK**

2. **Configure Pipeline:**
   - **Definition:** Pipeline script
   - Copy the entire content from `talentflow/Jenkinsfile`
   - Paste into **Script** field
   - Click **Save**

3. **Run the Pipeline:**
   - Click **Build Now**

## 🎯 Pipeline Stages Explained

The pipeline executes these stages in order:

1. **Checkout** - Clones the repository
2. **Install Dependencies** - Runs `npm ci` to install packages
3. **Test** - Runs React tests with `CI=true npm test`
4. **Build** - Creates production build with `npm run build`
5. **Docker Build** - Builds Docker image from Dockerfile
6. **Docker Push** - (Optional) Pushes image to Docker Hub
7. **Deploy** - (Optional) Runs deployment script

## 🔍 Viewing Pipeline Results

- **Console Output:** Click on any build number → **Console Output**
- **Pipeline Visualization:** Click **Pipeline Steps** to see stage-by-stage progress
- **Build History:** View all builds on the job's main page

## 🐛 Troubleshooting

### Build Fails at "Install Dependencies"
- Ensure Node.js is configured in Global Tool Configuration
- Check that `package.json` exists in the repository

### Build Fails at "Docker Build"
- Ensure Docker Desktop is running
- Verify Docker is accessible: `docker ps` should work
- Check that Dockerfile exists in the project root

### Build Fails at "Docker Push"
- Verify Docker Hub credentials are set with ID `dockerhub-creds`
- Check that `IMAGE_NAME` parameter matches your Docker Hub repository
- Ensure you have push permissions to the repository

### Tests Fail
- Review test output in Console Output
- Some warnings are acceptable; failures will stop the pipeline
- You can temporarily disable tests by commenting out the Test stage

## 📝 Customizing the Pipeline

Edit `talentflow/Jenkinsfile` to:
- Add more stages (e.g., linting, security scanning)
- Change build parameters
- Add deployment steps
- Configure notifications (email, Slack, etc.)

## 🎉 Success Indicators

A successful pipeline run will show:
- ✅ All stages completed (green checkmarks)
- ✅ Docker image built successfully
- ✅ (If enabled) Image pushed to Docker Hub
- ✅ Build artifacts available

## 📚 Additional Resources

- [Jenkins Pipeline Documentation](https://www.jenkins.io/doc/book/pipeline/)
- [Docker Pipeline Plugin](https://plugins.jenkins.io/docker-workflow/)
- [Jenkins Best Practices](https://www.jenkins.io/doc/book/pipeline/pipeline-best-practices/)

---

**Note:** For production use, consider:
- Setting up Jenkins agents for better performance
- Configuring webhooks for automatic builds on git push
- Adding security scanning stages
- Setting up proper backup strategies

