

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
     Find the ASP.NET application in this repository and modernize it to .NET 9.
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
2. Navigate to the `on-prem` resource group
3. Connect to the Hyper-V host VM (`lab@lab.LabInstance.Id-vm`)
4. Explore the nested VMs running inside the host

![Hyper-V Manager showing nested VMs](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/00915.png)

5. Verify that applications are running (e.g., http://172.100.2.110)

![Application running in nested VM](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/0013.png)

**Create Azure Migrate Project:**  

6. Create a new Azure Migrate project in the Azure Portal
7. Name your project (e.g., `migrate-prj`)
8. Select an appropriate region (e.g., Europe)

![Azure Migrate Discovery page](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/0090.png)

**Deploy the Azure Migrate Appliance:**

9. Generate a project key for the appliance
10. Download the Azure Migrate appliance VHD file

![Download appliance VHD](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/0091.png)

11. Extract the VHD inside your Hyper-V host (F: drive recommended)

![Extract VHD to F drive](https://raw.githubusercontent.com/CZSK-MicroHacks/MicroHack-MigrateModernize/refs/heads/main/lab-material/media/00914.png)

12. Create a new Hyper-V VM using the extracted VHD:
    - Name: `AZMAppliance`
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

Modernize the Contoso University .NET Framework application to .NET 9 and deploy it to Azure Container Apps using GitHub Copilot's AI-powered code transformation capabilities.

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

**Assess and Upgrade to .NET 9:**

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
- ✅ Application upgraded from .NET Framework to .NET 9
- ✅ Upgrade report generated showing all changes and issues
- ✅ Authentication migrated from Windows AD to Microsoft Entra ID
- ✅ All mandatory cloud readiness issues resolved
- ✅ Application successfully deployed to Azure Container Apps
- ✅ Deployed application is accessible and functional

### Learning Resources

- [GitHub Copilot for Visual Studio](https://learn.microsoft.com/visualstudio/ide/visual-studio-github-copilot-extension)
- [Modernize .NET Applications](https://learn.microsoft.com/dotnet/architecture/modernize-with-azure-containers/)
- [Migrate to .NET 9](https://learn.microsoft.com/dotnet/core/migration/)
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

**Setup Infrastructure as Code Repository:**

1. Navigate to your forked repository in GitHub
2. Create a new branch called `iac-deployment`
3. Create a new directory structure for IaC: `infrastructure/bicep` or `infrastructure/terraform`

**Define Azure Infrastructure:**

4. Create a main infrastructure template file (e.g., `main.bicep` or `main.tf`)
5. Define the following resources in your template:
   - Resource Group
   - Container Apps Environment
   - Container App (for ContosoUniversity)
   - Azure SQL Database
   - Azure Storage Account (for AssetManager)
   - Application Insights
   - Log Analytics Workspace

**Parameterize for Multiple Environments:**

6. Create environment-specific parameter files:
   - `parameters.dev.json`
   - `parameters.test.json`
   - `parameters.prod.json`
7. Define environment-specific values:
   - SKU/pricing tiers (lower for dev/test, production-grade for prod)
   - Database sizing
   - Naming conventions with environment prefix
8. Create variables for common configurations
9. Use secure parameter handling for sensitive values (connection strings, keys)

**Add Database Schema Deployment:**

10. Create a database migration script directory: `database/migrations`
11. Add SQL scripts for schema creation and initial data
12. Consider using tools like:
    - Entity Framework migrations for .NET
    - Flyway or Liquibase for Java applications
13. Document the database deployment order in a `README.md`

**Create Deployment Scripts:**

14. Create PowerShell deployment script: `deploy.ps1`
15. Add parameters for:
    - Environment name (dev/test/prod)
    - Azure subscription
    - Resource location
16. Include validation steps before deployment
17. Add rollback capabilities for failed deployments
18. Create Azure CLI alternative script: `deploy.sh` for cross-platform support

**Implement Application Configuration Management:**

19. Set up Azure App Configuration or Key Vault for runtime settings
20. Define application settings that vary per environment:
    - Database connection strings
    - Azure Storage connection strings
    - API endpoints
    - Feature flags
21. Use managed identities to access configuration securely

**Test IaC Deployment:**

22. Deploy to a test environment using your IaC scripts:
    ```powershell
    ./deploy.ps1 -Environment dev -Location eastus
    ```
23. Verify all resources are created correctly
24. Check resource tags and naming conventions
25. Validate application connectivity to database and storage

**Deploy Application Code:**

26. Create application deployment scripts
27. Build application container images or source code
28. Deploy to Azure Container Apps using:
    - Azure CLI: `az containerapp up` or `az containerapp create`
    - GitHub Actions with Container Apps deployment action
29. Run database migrations as part of deployment
30. Verify application starts successfully

**Create Deployment Documentation:**

31. Document the complete deployment process
32. Include prerequisites (Azure CLI, PowerShell modules, permissions)
33. Add troubleshooting section for common issues
34. Create a deployment checklist

### Success Criteria

- ✅ Infrastructure as Code templates created (Bicep or Terraform)
- ✅ Environment-specific parameter files for dev, test, and prod
- ✅ All Azure resources defined as code (Container Apps, SQL, Storage, etc.)
- ✅ Database schema deployment scripts created
- ✅ Deployment automation scripts (PowerShell/Bash) functional
- ✅ Successful deployment to at least one environment
- ✅ Application configuration managed through Azure services (App Configuration/Key Vault)
- ✅ Application code deploys successfully to provisioned infrastructure
- ✅ All deployments are idempotent (can be run multiple times safely)
- ✅ Comprehensive deployment documentation created

### Learning Resources

- [Azure Bicep Documentation](https://learn.microsoft.com/azure/azure-resource-manager/bicep/)
- [Terraform on Azure](https://learn.microsoft.com/azure/developer/terraform/)
- [Infrastructure as Code Best Practices](https://learn.microsoft.com/azure/architecture/framework/devops/iac)
- [Azure App Configuration](https://learn.microsoft.com/azure/azure-app-configuration/overview)
- [Azure Key Vault](https://learn.microsoft.com/azure/key-vault/general/overview)
- [Entity Framework Migrations](https://learn.microsoft.com/ef/core/managing-schemas/migrations/)
- [Azure CLI Deployment](https://learn.microsoft.com/cli/azure/webapp)

---

## Challenge 6 - Monitoring and Operational Excellence

### Goal

Establish comprehensive monitoring and observability for your applications and platform. Learn how to measure application "health", identify issues before users are impacted, evaluate the impact of changes, and quickly diagnose root causes. Configure automated alerts and set up Site Reliability Engineering (SRE) practices.

### Actions

**Enable Application Insights:**

1. Navigate to your Container App in Azure Portal
2. Enable Application Insights integration
3. Note the instrumentation key and connection string
4. Configure the ContosoUniversity application to use Application Insights:
   - Add Application Insights SDK NuGet package
   - Update `appsettings.json` with instrumentation key
5. Configure the AssetManager application similarly for Java:
   - Add Application Insights Java agent
   - Update `application.properties`

**Configure Custom Telemetry:**

6. Implement custom events tracking:
   - User registration events
   - Course enrollment actions
   - Asset upload operations
7. Add custom metrics:
   - Page load times
   - API response times
   - Database query durations
8. Implement dependency tracking for:
   - SQL Database calls
   - Azure Blob Storage operations
   - External API calls

**Set Up Availability Monitoring:**

9. Create availability tests (ping tests) for your applications:
   - Test from multiple geographic locations
   - Configure test frequency (every 5 minutes)
   - Set up appropriate timeout values
10. Create multi-step web tests for critical user flows:
    - User login flow
    - Course enrollment process
    - Asset upload and retrieval

**Configure Log Analytics:**

11. Create a Log Analytics workspace
12. Connect Application Insights to Log Analytics
13. Enable diagnostic logging for:
    - Container Apps logs (console, system)
    - SQL Database query performance logs
    - Azure Storage analytics logs

**Create Monitoring Dashboards:**

14. Build an operational dashboard in Azure Portal with:
    - Application response times (p50, p95, p99)
    - Request rates and failure rates
    - Database performance metrics (DTU/CPU usage)
    - Storage operations and bandwidth
15. Add custom KQL (Kusto Query Language) queries:
    ```kusto
    requests
    | where timestamp > ago(1h)
    | summarize count(), avg(duration) by bin(timestamp, 5m)
    | render timechart
    ```
16. Create a business metrics dashboard showing:
    - Active users
    - Course enrollments
    - Asset uploads

**Set Up Alerts and Notifications:**

17. Create alert rules for critical conditions:
    - HTTP 5xx errors exceed threshold
    - Response time p95 > 2 seconds
    - Application availability < 99%
    - Database DTU usage > 80%
18. Configure action groups:
    - Email notifications to operations team
    - SMS for critical alerts
    - Integration with Microsoft Teams or Slack
19. Set up smart detection for anomalies:
    - Failure rate anomalies
    - Performance degradation
    - Memory leak detection

**Implement Distributed Tracing:**

20. Enable distributed tracing across services
21. Configure correlation IDs for request tracking
22. Visualize end-to-end transaction flows in Application Insights
23. Identify bottlenecks in service dependencies

**Create Runbooks and Playbooks:**

24. Document incident response procedures
25. Create automated remediation runbooks:
    - Auto-restart Container App on repeated failures
    - Scale-out replicas on high CPU/memory
    - Database connection pool adjustment
26. Set up Azure Automation accounts for runbook execution

**Configure SRE Practices:**

27. Define Service Level Objectives (SLOs):
    - Availability target: 99.9% uptime
    - Performance target: p95 response time < 1 second
    - Error budget: 0.1% downtime per month
28. Create Service Level Indicators (SLIs) dashboards
29. Implement error budget tracking
30. Set up burn rate alerts to prevent SLO violations

**Test Monitoring and Alerting:**

31. Simulate failures to test alert configurations:
    - Stop Container App to trigger availability alerts
    - Generate load to test performance alerts
    - Introduce errors to test failure detection
32. Verify alert notifications are received
33. Test runbook execution for automated remediation
34. Document the time-to-detect and time-to-resolve metrics

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

**Set Up GitHub Actions Workflow:**

1. Navigate to your forked repository
2. Create `.github/workflows` directory if it doesn't exist
3. Create a new workflow file: `azure-deployment.yml`
4. Define workflow triggers:
   ```yaml
   on:
     push:
       branches: [main, develop]
     pull_request:
       branches: [main]
     workflow_dispatch:
   ```

**Implement Build Pipeline:**

5. Create build jobs for both applications:
   - .NET application build job:
     - Restore dependencies
     - Build solution
     - Run unit tests
     - Publish artifacts
   - Java application build job:
     - Maven dependency resolution
     - Compile and package
     - Run unit tests
     - Create JAR artifact
6. Configure build caching to speed up subsequent runs
7. Add code quality checks:
   - Run linters (dotnet format, checkstyle)
   - Security scanning (dependency vulnerability checks)
   - Code coverage reporting

**Configure Infrastructure Deployment Stage:**

8. Add infrastructure deployment job using your IaC from Challenge 5
9. Implement environment-based deployment strategy:
   - Dev environment: Auto-deploy on any commit to `develop` branch
   - Test environment: Auto-deploy on any commit to `main` branch
   - Prod environment: Manual approval required
10. Use GitHub Environments to manage deployment protection:
    - Create environments: Development, Testing, Production
    - Add required reviewers for Production
    - Configure environment secrets
11. Add infrastructure validation steps:
    - Bicep/Terraform linting
    - What-if/plan execution before actual deployment
    - Post-deployment resource verification

**Implement Database Migration Pipeline:**

12. Create a database migration job
13. Add migration validation:
    - Check for breaking changes
    - Validate migration scripts syntax
14. Execute migrations in order:
    - Dev: Automatic migration
    - Test: Automatic migration after infrastructure
    - Prod: Manual approval + automated migration
15. Implement rollback capability for failed migrations
16. Store migration history and audit logs

**Configure Application Deployment Stage:**

17. Create application deployment jobs
18. Deploy applications to Azure Container Apps:
    - Build and push container images to Azure Container Registry
    - Deploy new revisions to Container Apps
    - Configure revision management for blue-green deployment
    - Run smoke tests on new revision
    - Activate new revision and deactivate old
19. Configure deployment settings:
    - Container Apps environment variables
    - Connection strings from Key Vault
    - Application Insights instrumentation key
20. Implement deployment health checks

**Add Automated Testing Stages:**

21. Implement post-deployment validation tests:
    - Health check endpoints
    - Basic functionality tests
    - Integration tests
22. Add performance testing:
    - Load testing using Azure Load Testing or k6
    - Performance regression detection
23. Configure automated rollback on test failures

**Implement Progressive Deployment:**

24. Configure traffic splitting for canary deployments using Container Apps revisions
25. Start with 10% traffic to new revision
26. Monitor key metrics during canary phase:
    - Error rates
    - Response times
    - Application Insights alerts
27. Automatically promote or rollback based on metrics
28. Implement feature flags for gradual feature rollout

**Set Up Pipeline Monitoring:**

29. Configure pipeline failure notifications:
    - Email notifications for build failures
    - Microsoft Teams/Slack integration
    - GitHub mobile app notifications
30. Create pipeline performance dashboard:
    - Build duration trends
    - Deployment frequency metrics
    - Failure rates by environment
31. Implement deployment success tracking
32. Set up DORA metrics tracking:
    - Deployment frequency
    - Lead time for changes
    - Mean time to recovery (MTTR)
    - Change failure rate

**Implement Security and Compliance:**

33. Add security scanning stages:
    - Static Application Security Testing (SAST)
    - Dependency vulnerability scanning
    - Container image scanning
34. Implement secret scanning to prevent credential leaks
35. Add compliance checks:
    - Policy validation (Azure Policy)
    - Configuration compliance
36. Create audit logs for all deployments

**Configure Rollback and Recovery:**

37. Implement automated rollback triggers:
    - High error rate detected
    - Availability drops below threshold
    - Manual rollback capability
38. Create rollback workflow:
    - Revert to previous Container Apps revision
    - Restore previous database version if needed
    - Notify team of rollback
39. Document rollback procedures

**Create Pipeline Documentation:**

40. Document the complete pipeline architecture
41. Create a pipeline visualization diagram
42. Write runbook for pipeline failures
43. Document approval processes and responsibilities
44. Create onboarding guide for new team members

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
- Upgraded application from legacy .NET Framework to .NET 9
- Migrated from Windows AD to Microsoft Entra ID authentication
- Resolved cloud readiness issues identified in the upgrade report
- Deployed the modernized application to Azure App Service

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
- Defined Azure resources as code (App Service, SQL Database, Storage Account, Application Insights)
- Parameterized infrastructure for multiple environments (dev, test, prod)
- Implemented database schema deployment scripts
- Created automated deployment scripts (PowerShell and Bash)
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
