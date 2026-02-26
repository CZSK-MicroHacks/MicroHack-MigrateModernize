

# Azure Migration & Modernization MicroHack

This MicroHack scenario walks through a complete migration and modernization journey using Azure Migrate and GitHub Copilot. The experience covers discovery, assessment, business case development, and application modernization for both .NET and Java workloads.

## MicroHack Context

This MicroHack provides hands-on experience with the entire migration lifecycle - from initial discovery of on-premises infrastructure through to deploying modernized applications on Azure. You'll work with a simulated datacenter environment and use AI-powered tools to accelerate modernization.

**Key Technologies:**
- Azure Migrate for discovery and assessment
- GitHub Copilot for AI-powered code modernization
- Azure Container Apps for hosting modernized applications

## Environment creation

Install Azure PowerShell and authenticated to your Azure subscription:
```PowerShell
Install-Module Az
Connect-AzAccount
```

Please note:
- You need Administrator rights to install Azure PowerShell. If it's not an option for you, install it for the current user using `Install-Module Az -Scope CurrentUser`
- It takes some time (around 10 minutes) to install. Please, complete this task in advance.
- If you have multiple Azure subscriptions avaialble for your account, use `Connect-AzAccount -TenantId YOUR-TENANT-ID` to authenticate against specific one.

Once you are authenticated to Azure via PowerShell, run the following script to create the lab environment:

```Powershell
# Download and execute the environment creation script directly from GitHub
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-creation/New-MicroHackEnvironment.ps1" -OutFile "$env:TEMP\New-MicroHackEnvironment.ps1"
& "$env:TEMP\New-MicroHackEnvironment.ps1"
```

## Start your lab

**Business Scenario:**
You're working with an organization that has on-premises infrastructure running .NET and Java applications. Your goal is to assess the environment, build a business case for migration, and modernize applications using best practices and AI assistance.

## Objectives

After completing this MicroHack you will:

- Understand how to deploy and configure Azure Migrate for infrastructure discovery
- Know how to build compelling business cases using Azure Migrate data
- Analyze migration readiness across servers, databases, and applications
- Use GitHub Copilot to modernize .NET Framework applications to modern .NET
- Leverage AI to migrate Java applications from AWS dependencies to Azure services
- Deploy modernized applications to Azure Container Apps

## MicroHack Challenges

### General Prerequisites

This MicroHack has specific prerequisites to ensure optimal learning experience.

**Required Access:**
- Azure Subscription with Contributor permissions
- GitHub account with GitHub Copilot access

**Required Software:**
- Visual Studio 2022 (for .NET modernization)
- Visual Studio Code (for Java modernization)
- Docker Desktop
- Java Development Kit (JDK 8 and JDK 21)
- Maven

**Alternative: Use GitHub Codespaces** (recommended if you don't have required software installed locally)

If you don't have the required software installed locally, you can use **GitHub Codespaces** for application modernization. Codespaces provides a cloud-based development environment with VS Code and common development tools pre-configured.

**Benefits of Using Codespaces:**
- No local software installation required
- Pre-configured development environment
- Access from any device with a web browser
- Consistent development environment across team members

**How to Use Codespaces for Modernization:**

1. **Fork the Repository**: Navigate to the repository on GitHub and click the "Fork" button to create your own copy.

2. **Create a Codespace**:
   - In your forked repository, click the green **Code** button
   - Select the **Codespaces** tab
   - Click **Create codespace on main**
   - Wait for the environment to initialize (this may take a few minutes)

3. **Install GitHub Copilot App Modernization Extension**:
   
   Once your Codespace is running, install the GitHub Copilot App Modernization extension:
   
   - Open the Extensions view (Ctrl+Shift+X or Cmd+Shift+X on macOS)
   - Search for "GitHub Copilot App Modernization"
   - Click **Install**
   - Restart the Codespace if prompted
   - Sign in to GitHub Copilot when prompted

   > **Note**: You need a GitHub Copilot Pro, Pro+, Business, or Enterprise subscription to use this extension.

4. **Use GitHub Copilot for Autonomous Modernization**:
   
   The GitHub Copilot App Modernization extension can autonomously find and modernize applications. Here's how:
   
   **For .NET Applications (like ContosoUniversity):**
   - Navigate to the ContosoUniversity project in the Explorer
   - Open the GitHub Copilot App Modernization extension from the Activity Bar
   - Use the following example prompt in the Copilot Chat:
     ```
     Find the ASP.NET application in this repository and modernize it to .NET 10.
     Upgrade the framework, migrate authentication from Windows AD to Microsoft Entra ID,
     and prepare it for Azure Container Apps deployment.
     ```
   - The agent will analyze the application, create a migration plan, and execute the modernization autonomously
   
   **For Java Applications (like AssetManager):**
   - Navigate to the AssetManager project in the Explorer
   - Open the GitHub Copilot App Modernization extension from the Activity Bar
   - Click **Migrate to Azure** to trigger the assessment
   - Use example prompts like:
     ```
     Assess this Java application and identify all modernization opportunities.
     Migrate from AWS S3 to Azure Blob Storage, upgrade from Java 8 to Java 21,
     and migrate from Spring Boot 2.x to 3.x autonomously.
     ```
   - The agent will perform the assessment and execute the guided migration tasks
   
   **Alternative Prompt for Complete Modernization:**
   ```
   Find all applications in this repository (both .NET and Java) and create a
   comprehensive modernization plan. Execute the modernization autonomously,
   including framework upgrades, cloud migration, and Azure service integration.
   ```

5. **Monitor the Modernization Process**:
   - **Watch the Copilot Chat** for real-time status updates and progress
   - **Review Generated Files**: Check `plan.md`, `progress.md`, or `dotnet-upgrade-report.md` for detailed logs
   - **Allow Operations**: Click "Allow" when prompted for operations during the migration
   - **Review Code Changes**: The extension will show you the proposed changes in the editor
   - **Track Validation**: Monitor automated validation steps (CVE scanning, build validation, tests)

6. **Review and Apply Changes**:
   - **Review the Migration Plan**: Before execution starts, carefully review the generated migration plan
   - **Examine Code Diffs**: Use the Source Control view (Ctrl+Shift+G) to see all changes
   - **Test Incrementally**: After each major migration step completes, review and test the changes
   - **Click "Keep"**: When satisfied with the changes, click "Keep" to apply them
   - **Resolve Issues**: If validation fails, the agent will attempt to fix issues automatically
   - **Commit Changes**: Once all changes are validated, commit them to your branch

7. **Deploy to Azure**:
   - After modernization completes successfully, the agent can help you deploy to Azure
   - Follow the deployment prompts in the Copilot Chat
   - The agent will provision necessary Azure resources and deploy your application

**Important Notes:**
- The modernization process is **autonomous** but requires your **supervision and approval**
- Always **monitor the chat** for questions or confirmations from the agent
- **Review all code changes** before accepting them to ensure they meet your requirements
- The agent will create a **new branch** for changes, allowing you to review before merging
- **Validate the application** runs correctly after each major migration step
- Keep an eye on the **validation results** (CVE scans, build status, test results)

**Azure Resources:**
The lab environment provides:
- Resource Group: `on-prem`
- Hyper-V host VM with nested virtualization
- Pre-configured virtual machines simulating datacenter workloads
- Azure Migrate project with sample data

**Estimated Time:**
- Challenge 1: 45-60 minutes
- Challenge 2: 30-45 minutes
- Challenge 3: 45-60 minutes
- Challenge 4: 60-75 minutes
- Challenge 5: 45-60 minutes
- Challenge 6: 45-60 minutes
- Challenge 7: 60-90 minutes
- **Total: 5.25-7.5 hours**

---

## Challenge 1 - Prepare a Migration Environment

### Goal

Set up Azure Migrate to discover and assess your on-premises infrastructure. You'll install and configure an appliance that collects data about your servers, applications, and dependencies.

### Actions

**Understand Your Environment:**
1. Access the Azure Portal using the provided credentials
2. Navigate to the `onpremXXX-rg` resource group
3. Connect to the Hyper-V host VM `onpremXXX-vm` (login: `adminuser`, password: `demo!pass123`)
   - User RDP or Azure Bastion
5. Explore the nested VMs running inside the host

![Hyper-V Manager showing nested VMs](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/00915.png)

5. Verify that applications are running (e.g., http://172.100.2.110)

![Application running in nested VM](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/0013.png)

**Create Azure Migrate Project:**  

6. Create a new Azure Migrate project in the Azure Portal
7. Name your project (e.g., `migrate-prjXXX`)
8. Select an appropriate region (e.g., Europe)

![Azure Migrate Discovery page](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/0090.png)

**Deploy the Azure Migrate Appliance:**

9. Generate a project key for the appliance
10. Download the Azure Migrate appliance VHD file

![Download appliance VHD](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/0091.png)

11. Extract the VHD inside your Hyper-V host (F: drive recommended)

![Extract VHD to F drive](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/00914.png)

12. Create a new Hyper-V VM using the extracted VHD:
    - Name: `AZMApplianceXXX`
    - Generation: 1
    - RAM: 16384 MB
    - Network: NestedSwitch

![Create new VM in Hyper-V](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/0092.png)

![Select VHD file](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/00925.png)

13. Start the appliance VM

**Configure the Appliance:**

14. Accept license terms and set appliance password: `Demo!pass123`

![Send Ctrl+Alt+Del to appliance](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/0093.png)

15. Wait for Azure Migrate Appliance Configuration to load in browser

![Appliance Configuration Manager](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/00932.png)

16. Paste and verify your project key
17. Login to Azure through the appliance interface

![Login to Azure](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/00945.png)

18. Add Hyper-V host credentials (username: `adminuser`, password: `demo!pass123`)

![Add credentials](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/00946.png)

19. Add discovery source with Hyper-V host IP: `172.100.2.1`

![Add discovery source](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/00948.png)

20. Add credentials for Windows, Linux, SQL Server, and PostgreSQL workloads (password: `demo!pass123`)
    - Windows username: `Administrator`
    - Linux username: `demoadmin`
    - SQL username: `sa`

![Add workload credentials](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/009491.png)

21. Start the discovery process

### Success Criteria

- ✅ You have successfully connected to the Hyper-V host VM
- ✅ You can access nested VMs and verify applications are running
- ✅ Azure Migrate project has been created
- ✅ Appliance is deployed and connected to Azure Migrate

![Appliance in Azure Portal](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/00951.png)

- ✅ All appliance services show as running in Azure Portal

![Appliance services running](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/00952.png)

- ✅ Discovery process has started collecting data from your environment

### Learning Resources

- [Azure Migrate Overview](https://learn.microsoft.com/azure/migrate/migrate-services-overview)
- [Azure Migrate Appliance Architecture](https://learn.microsoft.com/azure/migrate/migrate-appliance-architecture)
- [Hyper-V Discovery with Azure Migrate](https://learn.microsoft.com/azure/migrate/tutorial-discover-hyper-v)
- [Azure Migrate Discovery Best Practices](https://learn.microsoft.com/azure/migrate/best-practices-assessment)

---

## Challenge 2 - Analyze Migration Data and Build a Business Case

### Goal

Transform raw discovery data into actionable insights by cleaning data, grouping workloads, creating business cases, and performing technical assessments to guide migration decisions.

### Actions

**Review Data Quality:**
1. Navigate to already prepared (with suffix `-azm`) Azure Migrate project overview

![Azure Migrate project overview](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/0095.png)

2. Open the Action Center to identify data quality issues

![Action Center with data issues](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/01005.png)

3. Review common issues (powered-off VMs, connection failures, missing performance data)
4. Understand the impact of data quality on assessment accuracy

**Group Workloads into Applications:**

5. Navigate to Applications page under "Explore applications"
6. Create a new application definition for "ContosoUniversity"
7. Set application type as "Custom" (source code available)
8. Link relevant workloads to the application
9. Filter and select all ContosoUniversity-related workloads

![Link workloads to application](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/01002.png)

10. Set criticality and complexity ratings

**Build a Business Case:**

11. Navigate to Business Cases section
12. Create a new business case named "contosouniversity"
13. Select "Selected Scope" and add ContosoUniversity application
14. Choose target region: West US 2
15. Configure Azure discount: 15%
16. Build the business case and wait for calculations

**Analyze an Existing Business Case:**

17. Open the pre-built "businesscase-for-paas" business case
18. Review annual cost savings and infrastructure scope
19. Examine current on-premises vs future Azure costs
20. Analyze CO₂ emissions reduction estimates
21. Review migration strategy recommendations (Rehost, Replatform, Refactor)
22. Examine Azure cost assumptions and settings

**Perform Technical Assessments:**

23. Navigate to Assessments section

![Assessments overview](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/01007.png)

24. Open the "businesscase-businesscase-for-paas" assessment

![Assessment details](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/01008.png)

25. Review recommended migration paths (PaaS preferred)
26. Analyze monthly costs by migration approach
27. Review Web Apps to Azure Container Apps assessment details
28. Identify "Ready with conditions" applications
29. Review ContosoUniversity application details
30. Check server operating system support status
31. Identify out-of-support and extended support components
32. Review PostgreSQL database version information
33. Examine software inventory on each server

![Software inventory details](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/01010.png)

**Complete Knowledge Checks:**

34. Find the count of powered-off Linux VMs

![Filter powered-off Linux VMs](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/01001.png)

35. Count Windows Server 2016 instances

![Windows Server 2016 count](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/01004.png)

36. Calculate VM costs for the ContosoUniversity application

![Application costs](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/01011.png)

37. Identify annual cost savings from the business case
38. Determine security cost savings

### Success Criteria

- ✅ You understand data quality issues and their impact on assessments
- ✅ Applications are properly grouped with related workloads
- ✅ Business case successfully created showing cost analysis and ROI
- ✅ You can navigate between business cases and technical assessments
- ✅ Migration strategies (Rehost, Replatform, Refactor) are clearly understood
- ✅ Application readiness status is evaluated for cloud migration
- ✅ Out-of-support components are identified for remediation
- ✅ You can answer specific questions about your environment using Azure Migrate data

### Learning Resources

- [Azure Migrate Business Case Overview](https://learn.microsoft.com/azure/migrate/concepts-business-case-calculation)
- [Azure Assessment Best Practices](https://learn.microsoft.com/azure/migrate/best-practices-assessment)
- [Application Discovery and Grouping](https://learn.microsoft.com/azure/migrate/how-to-create-group-machine-dependencies)
- [Migration Strategies: 6 Rs Explained](https://learn.microsoft.com/azure/cloud-adoption-framework/migrate/azure-best-practices/contoso-migration-refactor-web-app-sql)

---

## Challenge 3 - Modernize a .NET Application

### Goal

Modernize the Contoso University .NET Framework application to .NET 10 and deploy it to Azure Container Apps using GitHub Copilot's AI-powered code transformation capabilities.

> **💡 Tip**: If you don't have Visual Studio 2022 installed locally, you can complete this challenge using **GitHub Codespaces**. See the [Alternative: Use GitHub Codespaces](#alternative-use-github-codespaces) section in the prerequisites for setup instructions.

### Actions

**Setup and Preparation:**
1. Navigate to `https://github.com/CZSK-MicroHacks/MicroHack-MigrateModernize` and click the "Fork" button in the top-right corner

![Fork the repository](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/fork-button.png)

2. Select your account as the owner and click "Create fork"

![Create fork dialog](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/create-fork.png)

3. Once the fork is created, click the "Code" button and copy your forked repository URL

![Copy clone URL](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/clone-url.png)

4. Open Visual Studio 2022
5. Select "Clone a repository" and paste your forked repository URL
6. Navigate to Solution Explorer and locate the ContosoUniversity project
7. Rebuild the project to verify it compiles successfully

![Application running in IIS Express](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/0030.png)

**Assess and Upgrade to .NET 10:**

8. Right-click the ContosoUniversity project and select "Modernize"

![Right-click Modernize menu](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/0040.png)

9. Sign in to GitHub Copilot if prompted
10. Select Claude Sonnet 4.5 as the model
11. Click "Upgrade to a newer .NET version"
12. Allow GitHub Copilot to analyze the codebase
13. Review the upgrade plan when presented
14. Allow operations when prompted during the upgrade process
15. Wait for the upgrade to complete (marked by `dotnet-upgrade-report.md` appearing)

**Migrate to Azure:**

16. Right-click the project again and select "Modernize"
17. Click "Migrate to Azure" in the GitHub Copilot Chat window
18. Wait for GitHub Copilot to assess cloud readiness

**Resolve Cloud Readiness Issues:**
19. Open the `dotnet-upgrade-report.md` file

![Upgrade report with cloud readiness issues](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/0080.png)

20. Review the Cloud Readiness Issues section
21. Click "Migrate from Windows AD to Microsoft Entra ID"
22. Allow GitHub Copilot to implement the authentication changes
23. Ensure all mandatory tasks are resolved
24. Review the changes made to authentication configuration

**Deploy to Azure:**

25. Allow GitHub Copilot to complete the Azure Container Apps deployment
26. Verify the deployment succeeds
27. Test the deployed application in Azure

### Success Criteria

- ✅ ContosoUniversity solution cloned and builds successfully
- ✅ Application upgraded from .NET Framework to .NET 10
- ✅ Upgrade report generated showing all changes and issues
- ✅ Authentication migrated from Windows AD to Microsoft Entra ID
- ✅ All mandatory cloud readiness issues resolved
- ✅ Application successfully deployed to Azure Container Apps
- ✅ Deployed application is accessible and functional

### Learning Resources

- [GitHub Copilot for Visual Studio](https://learn.microsoft.com/visualstudio/ide/visual-studio-github-copilot-extension)
- [Modernize .NET Applications](https://learn.microsoft.com/dotnet/architecture/modernize-with-azure-containers/)
- [Migrate to .NET 10](https://learn.microsoft.com/dotnet/core/migration/)
- [Azure Container Apps for .NET](https://learn.microsoft.com/azure/container-apps/quickstart-code-to-cloud)
- [Microsoft Entra ID Authentication](https://learn.microsoft.com/azure/active-directory/develop/quickstart-v2-aspnet-core-webapp)

---

## Challenge 4 - Modernize a Java Application

### Goal

Modernize the Asset Manager Java Spring Boot application for Azure deployment, migrating from AWS dependencies to Azure services using GitHub Copilot App Modernization in VS Code.

> **💡 Tip**: If you don't have Docker Desktop, JDK, or Maven installed locally, you can complete this challenge using **GitHub Codespaces**. See the [Alternative: Use GitHub Codespaces](#alternative-use-github-codespaces) section in the prerequisites for setup instructions.

### Actions

**Environment Setup:**
1. Open Docker Desktop and ensure it's running
2 Open Terminal and run the setup commands:
   ```bash
   mkdir C:\gitrepos\lab
   cd C:\gitrepos\lab
   git clone https://github.com/CZSK-MicroHacks/MicroHack-MigrateModernize.git
   cd .\migrate-modernize-lab\src\AssetManager\
   code .
   ```
3. Login to GitHub from VS Code
4. Install GitHub Copilot App Modernization extension if not present

**Validate Application Locally:**

5. Open Terminal in VS Code (View → Terminal)
6. Run `scripts\startapp.cmd`
7. Wait for Docker containers (RabbitMQ, Postgres) to start
8. Allow network permissions when prompted
9. Verify application is accessible at http://localhost:8080
10. Stop the application by closing console windows

**Perform AppCAT Assessment:**

11. Open GitHub Copilot App Modernization extension in the Activity bar
12. Ensure Claude Sonnet 4.5 is selected as the model
13. Click "Migrate to Azure" to begin assessment
14. Wait for AppCAT CLI installation to complete
15. Review assessment progress in the VS Code terminal
16. Wait for assessment results (9 cloud readiness issues, 4 Java upgrade opportunities)

**Analyze Assessment Results:**

17. Review the assessment summary in GitHub Copilot chat
18. Examine issue prioritization:
    - Mandatory (Purple) - Critical blocking issues
    - Potential (Blue) - Performance optimizations
    - Optional (Gray) - Future improvements
19. Click on individual issues to see detailed recommendations
20. Focus on the AWS S3 to Azure Blob Storage migration finding

**Execute Guided Migration:**

21. Expand the "Migrate from AWS S3 to Azure Blob Storage" task
22. Read the explanation of why this migration is important
23. Click the "Run Task" button to start the migration
24. Review the generated migration plan in the chat window and `plan.md` file
25. Type "Continue" in the chat to begin code refactoring

**Monitor Migration Progress:**

26. Watch the GitHub Copilot chat for real-time status updates
27. Check the `progress.md` file for detailed change logs
28. Review file modifications as they occur:
    - `pom.xml` and `build.gradle` updates for Azure SDK dependencies
    - `application.properties` configuration changes
    - Spring Cloud Azure version properties
29. Allow any prompted operations during the migration

**Validate Migration:**

30. Wait for automated validation to complete:
    - CVE scanning for security vulnerabilities
    - Build validation
    - Consistency checks
    - Test execution
31. Review validation results in the chat window
32. Allow automated fixes if validation issues are detected
33. Confirm all validation stages pass successfully

**Test Modernized Application:**

34. Open Terminal in VS Code
35. Run `scripts\startapp.cmd` again
36. Verify the application starts with Azure Blob Storage integration
37. Test application functionality at http://localhost:8080
38. Confirm no errors related to storage operations

**Optional: Continue Modernization:**

39. Review other migration tasks in the assessment report
40. Execute additional migrations as time permits
41. Track progress through the `plan.md` and `progress.md` files

### Success Criteria

- ✅ Docker Desktop is running and containers are functional
- ✅ Asset Manager application cloned and runs locally
- ✅ AppCAT assessment completed successfully
- ✅ Assessment identifies 9 cloud readiness issues and 4 Java upgrade opportunities
- ✅ AWS S3 to Azure Blob Storage migration executed via guided task
- ✅ Maven/Gradle dependencies updated with Azure SDK
- ✅ Application configuration migrated to Azure Blob Storage
- ✅ All validation stages pass (CVE, build, consistency, tests)
- ✅ Modernized application runs successfully locally
- ✅ Migration changes tracked in dedicated branch for rollback capability

### Learning Resources

- [GitHub Copilot for VS Code](https://code.visualstudio.com/docs/copilot/overview)
- [Azure SDK for Java](https://learn.microsoft.com/azure/developer/java/sdk/)
- [Migrate from AWS to Azure](https://learn.microsoft.com/azure/architecture/aws-professional/)
- [Azure Blob Storage for Java](https://learn.microsoft.com/azure/storage/blobs/storage-quickstart-blobs-java)
- [Spring Cloud Azure](https://learn.microsoft.com/azure/developer/java/spring-framework/)
- [AppCAT Assessment Tool](https://learn.microsoft.com/azure/developer/java/migration/migration-toolkit-intro)

---

## Challenge 5 - Deploying Applications and Data with Code

### Goal

Build a repeatable Infrastructure as Code (IaC) deployment method that produces consistent results across multiple environments (dev/test/prod), reduces the risk of manual errors, and enables rapid adjustments to infrastructure and application configurations.

### Actions

**Use GitHub Copilot for IaC Development:**

> **💡 Pro Tip**: Use GitHub Copilot Chat to accelerate your Infrastructure as Code development throughout this challenge. Copilot can help generate Bicep/Terraform templates, deployment scripts, and configuration files.

**Setup Infrastructure as Code Repository:**

1. Navigate to your forked repository in GitHub
2. Create a new branch called `iac-deployment`
3. Create a new directory structure for IaC: `infrastructure/bicep` or `infrastructure/terraform`

**Define Azure Infrastructure with GitHub Copilot:**

4. Open GitHub Copilot Chat in your IDE (VS Code or Visual Studio)
5. Use the following prompt to generate infrastructure templates:
   ```
   Generate a Bicep template for Azure Container Apps infrastructure including:
   - Log Analytics Workspace
   - Application Insights
   - Azure Container Registry
   - Container Apps Environment (depends on Log Analytics)
   - Azure SQL Database
   - Azure Storage Account
   - Container App for a .NET application
   
   Include parameters for environment name, location, and resource names.
   ```
6. Review and customize the generated template for your needs
7. Ask Copilot to explain any sections you don't understand:
   ```
   Explain the Container Apps Environment configuration and its dependencies
   ```

**Parameterize for Multiple Environments:**

8. Create environment-specific parameter files using GitHub Copilot:
   ```
   Create parameter files for dev, test, and prod environments with appropriate SKU sizes:
   - Dev: Basic/Free tiers where possible
   - Test: Standard tiers
   - Prod: Premium tiers with high availability
   
   Include parameters for:
   - Database sizing (DTU or vCores)
   - Container Apps scaling configuration
   - Storage redundancy levels
   ```
9. Review the generated parameter files and adjust values as needed
10. Use GitHub Copilot to generate deployment scripts:
    ```
    Create a PowerShell script that deploys Bicep templates with parameter files.
    Include error handling, resource validation, and rollback capabilities.
    ```

**Add Database Schema Deployment:**

11. Use GitHub Copilot to generate database migration scripts:
    ```
    Create SQL migration scripts for the ContosoUniversity database schema.
    Include scripts for:
    - Creating tables (Students, Courses, Enrollments)
    - Adding indexes and constraints
    - Seeding initial data
    ```
12. Generate a deployment order script:
    ```
    Create a PowerShell script that runs SQL migrations in the correct order
    with transaction support and rollback capabilities.
    ```

**Create Deployment Scripts with GitHub Copilot:**

13. Ask GitHub Copilot to create deployment automation:
    ```
    Create a comprehensive PowerShell deployment script (deploy.ps1) that:
    - Validates Azure CLI installation and authentication
    - Accepts parameters for environment (dev/test/prod), subscription, and location
    - Deploys Bicep templates with appropriate parameter files
    - Waits for deployment completion with progress feedback
    - Validates all resources were created successfully
    - Includes detailed error handling and logging
    ```
14. Review and test the generated script
15. Ask Copilot to create a cross-platform Bash version:
    ```
    Convert the deploy.ps1 script to a Bash script (deploy.sh) for Linux/macOS users
    ```

**Implement Application Configuration Management:**

16. Use GitHub Copilot to set up configuration management:
    ```
    Show me how to configure Azure Key Vault for storing application secrets and
    how to reference these secrets in Azure Container Apps using managed identities.
    Include Bicep code for:
    - Creating Key Vault
    - Storing connection strings as secrets
    - Configuring Container App to access secrets via managed identity
    ```
17. Review and implement the generated configuration code

**Test IaC Deployment:**

18. Deploy to a test environment using your generated scripts:
    ```powershell
    ./deploy.ps1 -Environment dev -Location eastus
    ```
19. Verify all resources are created correctly
20. Check resource tags and naming conventions
21. Validate application connectivity to database and storage

**Deploy Application Code:**

22. Use GitHub Copilot to create container deployment scripts:
    ```
    Create a script that:
    1. Builds a Docker image from the .NET application
    2. Pushes the image to Azure Container Registry
    3. Deploys the image to Azure Container Apps
    4. Runs database migrations
    5. Verifies the application is running
    ```
23. Execute the deployment and verify the application starts successfully

**Create Deployment Documentation:**

24. Ask GitHub Copilot to generate comprehensive documentation:
    ```
    Create a detailed README.md for the infrastructure deployment that includes:
    - Prerequisites and required tools
    - Step-by-step deployment instructions
    - Environment-specific configurations
    - Troubleshooting guide for common issues
    - Architecture diagram description
    ```
25. Review and enhance the generated documentation

### Success Criteria

- ✅ Infrastructure as Code templates created (Bicep or Terraform)
- ✅ Environment-specific parameter files for dev, test, and prod
- ✅ All Azure resources defined as code (Container Apps, Container Registry, SQL, Storage, etc.)
- ✅ Database schema deployment scripts created
- ✅ Deployment automation scripts (PowerShell/Bash) functional
- ✅ Successful deployment to at least one environment
- ✅ Application configuration managed through Azure services (App Configuration/Key Vault)
- ✅ Container images built and pushed to Azure Container Registry
- ✅ Application deploys successfully to Container Apps from ACR
- ✅ All deployments are idempotent (can be run multiple times safely)
- ✅ Comprehensive deployment documentation created

### Learning Resources

- [Azure Bicep Documentation](https://learn.microsoft.com/azure/azure-resource-manager/bicep/)
- [Terraform on Azure](https://learn.microsoft.com/azure/developer/terraform/)
- [Infrastructure as Code Best Practices](https://learn.microsoft.com/azure/architecture/framework/devops/iac)
- [Azure Container Apps](https://learn.microsoft.com/azure/container-apps/overview)
- [Azure Container Registry](https://learn.microsoft.com/azure/container-registry/container-registry-intro)
- [Azure App Configuration](https://learn.microsoft.com/azure/azure-app-configuration/overview)
- [Azure Key Vault](https://learn.microsoft.com/azure/key-vault/general/overview)
- [Entity Framework Migrations](https://learn.microsoft.com/ef/core/managing-schemas/migrations/)
- [Deploy to Container Apps](https://learn.microsoft.com/azure/container-apps/quickstart-code-to-cloud)

---

## Challenge 6 - Monitoring and Operational Excellence

### Goal

Establish comprehensive monitoring and observability for your applications and platform. Learn how to measure application "health", identify issues before users are impacted, evaluate the impact of changes, and quickly diagnose root causes. Configure automated alerts and set up Site Reliability Engineering (SRE) practices.

### Actions

**Use GitHub Copilot for Monitoring Setup:**

> **💡 Pro Tip**: GitHub Copilot can help you configure monitoring, generate KQL queries, create alert rules, and build monitoring dashboards throughout this challenge.

**Enable Application Insights with GitHub Copilot:**

1. Open GitHub Copilot Chat and ask:
   ```
   How do I configure Application Insights in a .NET 10 application deployed to Azure Container Apps?
   Show me the code for appsettings.json and the necessary NuGet packages.
   ```
2. Review and implement the Application Insights configuration
3. For Java applications, ask:
   ```
   Configure Application Insights Java agent for a Spring Boot application.
   Show me the application.properties configuration.
   ```
4. Deploy the updated applications with monitoring enabled

**Configure Custom Telemetry with Copilot:**

5. Ask GitHub Copilot to generate custom telemetry code:
   ```
   Create custom Application Insights tracking for:
   - User registration events with user properties
   - Course enrollment actions with course and user data
   - Asset upload operations with file metadata
   
   Show me the C# code using Application Insights SDK.
   ```
6. Implement the generated telemetry code in your applications
7. For custom metrics, ask:
   ```
   Show me how to track custom metrics in Application Insights:
   - Page load times
   - API response times
   - Database query durations
   ```

**Set Up Availability Monitoring:**

8. Configure availability tests through Azure Portal or ask Copilot:
   ```
   Create an availability test configuration for Azure Container Apps monitoring.
   Include multi-region testing and alert configuration.
   ```

**Create Monitoring Dashboards with GitHub Copilot:**

9. Ask GitHub Copilot to generate KQL queries for your dashboards:
   ```
   Create KQL queries for Application Insights that show:
   1. Application response times (p50, p95, p99) over the last 24 hours
   2. Request rates and failure rates by endpoint
   3. Top 10 slowest requests
   4. Error rate trends with annotations
   5. Custom event tracking for business metrics (enrollments, uploads)
   ```
10. Copy the generated queries and create dashboard tiles in Azure Portal
11. Ask for more complex queries:
    ```
    Create a KQL query that correlates failed requests with their dependencies
    (database, storage) to identify root causes of failures.
    ```

**Set Up Alerts with GitHub Copilot:**

12. Generate alert rule configurations:
    ```
    Create Azure Monitor alert rules in Bicep/Terraform for:
    - HTTP 5xx errors exceeding 5% of requests
    - Response time p95 > 2 seconds for 5 minutes
    - Application availability < 99%
    - Container App replica failures
    - Database DTU/CPU usage > 80%
    
    Include action groups with email and Teams notifications.
    ```
13. Deploy the alert configurations
    - Integration with Microsoft Teams or Slack
19. Set up smart detection for anomalies:
    - Failure rate anomalies
    - Performance degradation
    - Memory leak detection

**Create Runbooks with GitHub Copilot:**

14. Ask GitHub Copilot to generate automated remediation scripts:
    ```
    Create a PowerShell runbook for Azure Automation that:
    1. Monitors Container App health status
    2. Automatically restarts the Container App if it fails health checks
    3. Scales out replicas if CPU/memory usage exceeds thresholds
    4. Sends notifications to Teams channel
    5. Logs all actions for audit trail
    ```
15. Review and deploy the runbook to Azure Automation

**Configure SRE Practices with Copilot:**

16. Generate SLO/SLI tracking queries:
    ```
    Create KQL queries to track Service Level Indicators:
    - Availability SLI: percentage of successful requests (non-5xx)
    - Latency SLI: p95 response time
    - Error budget calculation and burn rate
    
    Include queries for alerting when error budget is at risk.
    ```
17. Create dashboards to visualize SLOs and error budgets
18. Set up proactive alerts based on burn rate

**Test Monitoring System:**

19. Use GitHub Copilot to create test scripts:
    ```
    Create a load testing script using k6 or Apache JMeter that:
    - Simulates normal user traffic
    - Gradually increases load to trigger performance alerts
    - Introduces errors to test failure detection
    - Validates alert notifications are sent
    ```
20. Execute tests and verify monitoring and alerting work as expected

### Success Criteria

- ✅ Application Insights enabled and collecting telemetry
- ✅ Custom events and metrics implemented in applications
- ✅ Availability tests configured from multiple locations
- ✅ Log Analytics workspace connected and collecting logs
- ✅ Operational dashboards created showing key metrics
- ✅ Alert rules configured for critical conditions
- ✅ Action groups set up with appropriate notification channels
- ✅ Distributed tracing enabled across services
- ✅ Incident response runbooks documented
- ✅ SLOs and SLIs defined and tracked
- ✅ Monitoring system tested and validated through simulated failures

### Learning Resources

- [Application Insights Overview](https://learn.microsoft.com/azure/azure-monitor/app/app-insights-overview)
- [Azure Monitor Documentation](https://learn.microsoft.com/azure/azure-monitor/)
- [KQL Query Language](https://learn.microsoft.com/azure/data-explorer/kusto/query/)
- [Azure Alerts](https://learn.microsoft.com/azure/azure-monitor/alerts/alerts-overview)
- [Distributed Tracing](https://learn.microsoft.com/azure/azure-monitor/app/distributed-tracing)
- [Site Reliability Engineering (SRE)](https://learn.microsoft.com/azure/site-reliability-engineering/)
- [SLOs and Error Budgets](https://sre.google/workbook/implementing-slos/)
- [Azure Automation Runbooks](https://learn.microsoft.com/azure/automation/automation-runbook-types)

---

## Challenge 7 - End-to-End Deployment Automation

### Goal

Create a complete end-to-end deployment pipeline that connects all previous challenges into an automated, repeatable workflow. Implement continuous integration and continuous deployment (CI/CD) practices that enable teams to release changes safely, consistently, and with confidence—from code commit to production deployment.

### Actions

**Use GitHub Copilot for CI/CD Pipeline Development:**

> **💡 Pro Tip**: GitHub Copilot can generate complete GitHub Actions workflows, deployment scripts, and help you implement advanced CI/CD patterns throughout this challenge.

**Set Up GitHub Actions Workflow with Copilot:**

1. Navigate to your forked repository
2. Create `.github/workflows` directory if it doesn't exist
3. Open GitHub Copilot Chat and ask:
   ```
   Create a GitHub Actions workflow for deploying a .NET 10 application to Azure Container Apps.
   Include:
   - Triggers for push to main/develop branches and pull requests
   - Build and test jobs for .NET application
   - Docker image build and push to Azure Container Registry
   - Deployment to Container Apps with environment separation (dev/test/prod)
   - Manual approval gate for production
   ```
4. Review and save the generated workflow as `azure-deployment.yml`

**Implement Build Pipeline with Copilot:**

5. Ask GitHub Copilot to enhance the build pipeline:
   ```
   Add to the GitHub Actions workflow:
   - Dependency caching for faster builds
   - Code quality checks (linting with dotnet format)
   - Security scanning (Dependabot, CodeQL)
   - Code coverage reporting with threshold enforcement
   - Artifact upload for build outputs
   ```
6. For Java applications, ask:
   ```
   Create a GitHub Actions job for building a Java Spring Boot application:
   - Maven build with dependency caching
   - Unit test execution with JaCoCo coverage
   - Security scanning with OWASP dependency check
   - JAR artifact creation and upload
   ```

**Configure Infrastructure Deployment with Copilot:**

7. Ask GitHub Copilot to create infrastructure deployment jobs:
   ```
   Add a GitHub Actions job that:
   - Deploys Bicep templates from Challenge 5
   - Uses environment-specific parameter files
   - Implements environment-based deployment:
     * Dev: Auto-deploy on develop branch
     * Test: Auto-deploy on main branch  
     * Prod: Requires manual approval
   - Validates deployment using Azure CLI
   - Includes rollback on failure
   ```
8. Set up GitHub Environments with protection rules
9. Configure environment secrets for Azure credentials

**Implement Database Migration Pipeline:**

10. Generate database migration automation:
    ```
    Create a GitHub Actions job for database migrations that:
    - Validates SQL script syntax
    - Checks for breaking schema changes
    - Runs migrations with Entity Framework or SQL scripts
    - Implements automatic rollback on failures
    - Logs all migration activities
    ```

**Configure Application Deployment with Copilot:**

11. Ask GitHub Copilot to create container deployment automation:
    ```
    Create a GitHub Actions job that:
    - Builds Docker image for .NET 10 application
    - Pushes image to Azure Container Registry with version tags
    - Deploys new revision to Azure Container Apps
    - Implements blue-green deployment with traffic splitting
    - Runs smoke tests on new revision before full rollout
    - Configures environment variables from Key Vault
    - Includes automatic rollback on health check failures
    ```
12. Review and implement the generated deployment workflow

**Add Automated Testing with Copilot:**

13. Generate comprehensive test automation:
    ```
    Create GitHub Actions jobs for post-deployment testing:
    - Health check validation (HTTP 200 responses)
    - Integration tests for key user flows
    - Performance tests using k6 or Azure Load Testing
    - Automated rollback trigger on test failures
    - Test result reporting and notifications
    ```

**Implement Progressive Deployment:**

14. Ask Copilot for canary deployment strategy:
    ```
    Create a GitHub Actions workflow that implements canary deployment:
    - Deploy new revision with 10% traffic split
    - Monitor Application Insights metrics for 10 minutes
    - Automatically promote to 50% if metrics are healthy
    - Gradually increase to 100% if no issues detected
    - Automatic rollback if error rate > threshold
    ```

**Set Up Pipeline Monitoring:**

15. Generate DORA metrics tracking:
    ```
    Create a script that tracks DORA metrics from GitHub Actions:
    - Deployment frequency (commits to production per day)
    - Lead time (commit to deployment time)
    - Mean time to recovery (incident to resolution time)
    - Change failure rate (deployments causing incidents)
    
    Export metrics to Azure Monitor or create GitHub Actions dashboard.
    ```

**Implement Security and Compliance:**

16. Use GitHub Copilot to add security scanning:
    ```
    Add to the GitHub Actions workflow:
    - CodeQL analysis for static application security testing
    - Trivy or Grype for container image vulnerability scanning
    - Dependabot alerts integration
    - Secret scanning to prevent credential leaks
    - Azure Policy compliance validation
    ```

**Create Pipeline Documentation:**

17. Ask GitHub Copilot to generate comprehensive documentation:
    ```
    Create a complete CI/CD pipeline documentation that includes:
    - Architecture diagram in Mermaid format
    - Step-by-step workflow explanation
    - Environment configuration guide
    - Rollback procedures
    - Troubleshooting guide for common pipeline failures
    - Team responsibilities and approval processes
    ```

### Success Criteria

- ✅ GitHub Actions workflows created for all applications
- ✅ Build pipelines execute successfully with tests and quality checks
- ✅ Infrastructure deployment automated via IaC templates
- ✅ Database migrations integrated into deployment pipeline
- ✅ Application deployment to Azure Container Apps automated
- ✅ Multiple environments configured (Dev, Test, Prod) with appropriate gates
- ✅ Blue-green or canary deployment strategy implemented
- ✅ Automated testing stages validate deployments
- ✅ Progressive deployment with traffic splitting configured
- ✅ Pipeline monitoring and notifications active
- ✅ Security scanning integrated into pipeline
- ✅ Automated and manual rollback capabilities functional
- ✅ Complete end-to-end deployment succeeds from commit to production
- ✅ DORA metrics tracking implemented
- ✅ Comprehensive pipeline documentation created

### Learning Resources

- [GitHub Actions Documentation](https://docs.github.com/actions)
- [GitHub Actions for Azure](https://learn.microsoft.com/azure/developer/github/github-actions)
- [Azure DevOps vs GitHub Actions](https://learn.microsoft.com/azure/developer/github/github-actions-vs-azure-devops)
- [Azure Container Apps Revisions](https://learn.microsoft.com/azure/container-apps/revisions)
- [Blue-Green Deployments with Container Apps](https://learn.microsoft.com/azure/container-apps/blue-green-deployment)
- [Canary Deployments](https://learn.microsoft.com/azure/architecture/framework/devops/deployment-patterns)
- [GitHub Environments](https://docs.github.com/actions/deployment/targeting-different-environments/using-environments-for-deployment)
- [Azure Load Testing](https://learn.microsoft.com/azure/load-testing/overview-what-is-azure-load-testing)
- [DORA Metrics](https://cloud.google.com/blog/products/devops-sre/using-the-four-keys-to-measure-your-devops-performance)
- [CI/CD Best Practices](https://learn.microsoft.com/azure/architecture/framework/devops/checklist)

---

## Finish

Congratulations! You've completed the Azure Migration & Modernization MicroHack. 

**What You've Accomplished:**

Throughout this MicroHack, you've gained hands-on experience with the complete migration lifecycle:

### Challenge 1: Migration Preparation

- Explored a simulated datacenter environment with nested Hyper-V VMs
- Created and configured an Azure Migrate project for discovery
- Downloaded, installed, and configured the Azure Migrate appliance
- Connected the appliance to on-premises infrastructure with proper credentials
- Initiated continuous discovery for performance and dependency data collection

### Challenge 2: Migration Analysis & Business Case

- Reviewed and cleaned migration data using Azure Migrate's Action Center
- Grouped related VMs into logical applications (ContosoUniversity)
- Built business cases showing financial justification with cost savings and ROI analysis
- Analyzed technical assessments for cloud readiness and migration strategies
- Evaluated workload readiness across VMs, databases, and web applications
- Navigated migration data to identify issues, costs, and modernization opportunities

### Challenge 3: .NET Application Modernization

- Cloned and configured the Contoso University .NET application repository
- Used GitHub Copilot App Modernization extension in Visual Studio
- Performed comprehensive code assessment for cloud readiness
- Upgraded application from legacy .NET Framework to .NET 10
- Migrated from Windows AD to Microsoft Entra ID authentication
- Resolved cloud readiness issues identified in the upgrade report
- Deployed the modernized application to Azure Container Apps

### Challenge 4: Java Application Modernization

- Set up local Java development environment with Docker and Maven
- Ran the Asset Manager application locally to validate functionality
- Used GitHub Copilot App Modernization extension in VS Code
- Performed AppCAT assessment for Azure migration readiness (9 cloud readiness issues, 4 Java upgrade opportunities)
- Executed guided migration tasks to modernize the application
- Migrated from AWS S3 to Azure Blob Storage with automated code refactoring
- Validated migration success through automated CVE, build, consistency, and test validation
- Tested the modernized application locally

### Challenge 5: Infrastructure as Code Deployment

- Created Infrastructure as Code templates (Bicep or Terraform)
- Defined Azure resources as code (Container Apps, Container Registry, SQL Database, Storage Account, Application Insights)
- Parameterized infrastructure for multiple environments (dev, test, prod)
- Implemented database schema deployment scripts
- Created automated deployment scripts (PowerShell and Bash)
- Built and pushed container images to Azure Container Registry
- Configured Azure App Configuration or Key Vault for application settings
- Successfully deployed infrastructure and applications to Azure
- Established repeatable, consistent deployment process

### Challenge 6: Monitoring and Operational Excellence

- Enabled Application Insights for comprehensive telemetry collection
- Implemented custom events, metrics, and distributed tracing
- Configured availability tests from multiple geographic locations
- Set up Log Analytics workspace and connected logging
- Created operational dashboards with KQL queries
- Configured alert rules and action groups for critical conditions
- Documented incident response runbooks
- Defined Service Level Objectives (SLOs) and Service Level Indicators (SLIs)
- Tested monitoring system through simulated failures
- Established SRE practices for operational excellence

### Challenge 7: End-to-End Deployment Automation

- Created GitHub Actions workflows for CI/CD pipeline
- Implemented build pipelines with automated testing and quality checks
- Automated infrastructure deployment with environment-specific gates
- Integrated database migrations into deployment pipeline
- Configured blue-green or canary deployment strategies
- Set up multiple environments (Dev, Test, Production) with approval workflows
- Implemented progressive deployment with traffic splitting
- Added security scanning and compliance checks
- Configured automated rollback capabilities
- Established DORA metrics tracking for continuous improvement
- Created end-to-end automated deployment from code commit to production

---

**Skills Acquired:**

- Azure Migrate configuration and management
- Business case development and financial analysis
- AI-powered code modernization with GitHub Copilot
- Migration strategy selection (Rehost, Replatform, Refactor)
- Cloud readiness assessment and remediation
- Azure Container Apps deployment
- AppCAT assessment for Java applications
- Automated validation and testing workflows
- Infrastructure as Code (IaC) with Bicep/Terraform
- Multi-environment deployment strategies
- Azure monitoring and observability
- Application Insights and Log Analytics
- Alert configuration and incident response
- SRE practices and SLO/SLI implementation
- CI/CD pipeline development with GitHub Actions
- Blue-green and canary deployment patterns
- Automated testing and security scanning
- DORA metrics and DevOps performance tracking

**Key Takeaways:**

This workshop demonstrated the complete migration lifecycle from discovery to deployment:
- **Assessment First**: Azure Migrate provides comprehensive discovery and financial justification before migration
- **AI-Powered Modernization**: GitHub Copilot dramatically accelerates code modernization while maintaining quality
- **Platform Migration**: Successfully migrated dependencies (S3 to Blob Storage, Windows AD to Entra ID) alongside application code
- **Validation at Every Step**: Automated testing ensures functionality is preserved throughout modernization
- **Multiple Technology Stacks**: Experience with both .NET and Java modernization approaches
- **Infrastructure as Code**: Repeatable, consistent deployments across environments reduce errors and enable rapid adjustments
- **Operational Excellence**: Comprehensive monitoring and SRE practices ensure application health and quick incident response
- **Automation Pipeline**: End-to-end CI/CD enables fast, safe, and confident releases with automated quality gates

---

### Next Steps & Learning Paths

**Continue Your Azure Journey:**

- [Azure Migrate Documentation](https://learn.microsoft.com/azure/migrate/) - Deep dive into migration tools and strategies
- [Azure Well-Architected Framework](https://learn.microsoft.com/azure/well-architected/) - Learn enterprise architecture best practices
- [GitHub Copilot for Azure](https://learn.microsoft.com/azure/developer/github-copilot/) - Explore AI-powered development tools

**Hands-On Labs:**

- [Azure Migration Center](https://azure.microsoft.com/migration/) - Additional migration resources and tools
- [Azure Architecture Center](https://learn.microsoft.com/azure/architecture/) - Reference architectures and patterns
- [Microsoft Learn - Azure Migration Path](https://learn.microsoft.com/training/paths/migrate-modernize-innovate-azure/) - Structured learning modules

**Continue Modernization:**

- Explore additional migration scenarios in your own environments
- Practice with other workload types (containers, databases, etc.)
- Experiment with GitHub Copilot for other modernization tasks
- Continue with other migration tasks identified in the assessment reports
- Explore containerization options for deploying to AKS or Azure Container Apps
- Implement additional Azure services like Azure Service Bus (replacing RabbitMQ)
- Apply Java runtime upgrades using the identified opportunities
- Configure managed identities for passwordless authentication

If you want to give feedback, please don't hesitate to open an issue on the repository or get in touch with one of us directly.

Thank you for investing the time and see you next time!

---

## Additional Resources

- [Azure Migrate Documentation](https://learn.microsoft.com/azure/migrate/)
- [Azure Migration Center](https://azure.microsoft.com/migration/)
- [GitHub Copilot Documentation](https://docs.github.com/copilot)
- [Azure Well-Architected Framework](https://learn.microsoft.com/azure/well-architected/)
- [Cloud Adoption Framework](https://learn.microsoft.com/azure/cloud-adoption-framework/)
- [Microsoft Learn - Azure Migration Path](https://learn.microsoft.com/training/paths/migrate-modernize-innovate-azure/)
