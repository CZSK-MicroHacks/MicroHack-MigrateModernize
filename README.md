

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
- Challenge 3: 60-75 minutes
- Challenge 4: 30-45 minutes
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

## Challenge 3 - Modernize a Java Application

### Goal

Modernize the Asset Manager Java Spring Boot application for Azure deployment, migrating from AWS dependencies to Azure services using GitHub Copilot App Modernization in VS Code.

### Actions

**Perform AppCAT Assessment:**

1. Open GitHub Copilot App Modernization extension in the Activity bar
2. Ensure Claude Sonnet 4.5 is selected as the model
3. Click "Migrate to Azure" to begin assessment
4. Wait for AppCAT CLI installation to complete
5. Review assessment progress in the VS Code terminal
6. Wait for assessment results

**Analyze Assessment Results:**

7. Examine issue prioritization:
    - Mandatory (Purple) - Critical blocking issues
    - Potential (Blue) - Performance optimizations
    - Optional (Gray) - Future improvements
8. Click on individual issues to see detailed recommendations
9. Focus on the AWS S3 to Azure Blob Storage migration finding

**Execute Guided Migration:**

10. Expand the "Migrate from AWS S3 to Azure Blob Storage" task
11. Read the explanation of why this migration is important
12. Click the "Run Task" button to start the migration
13. Review the generated migration plan in the chat window and `plan.md` file
14. Type "Continue" in the chat to begin code refactoring

**Monitor Migration Progress:**

15. Watch the GitHub Copilot chat for real-time status updates
16. Check the `progress.md` file for detailed change logs
17. Review file modifications as they occur:
    - `pom.xml` updates for Azure SDK dependencies
    - `application.properties` configuration changes
    - Spring Cloud Azure version properties
18. Allow any prompted operations during the migration

**Validate Migration:**

19. Wait for automated validation to complete:
    - CVE scanning for security vulnerabilities
    - Build validation
    - Consistency checks
    - Test execution
20. Review validation results in the chat window
21. Allow automated fixes if validation issues are detected
22. Confirm all validation stages pass successfully

### Success Criteria

- ✅ AppCAT assessment completed successfully
- ✅ AWS S3 to Azure Blob Storage migration executed via guided task
- ✅ Maven dependencies updated with Azure SDK
- ✅ Application configuration migrated to Azure Blob Storage
- ✅ All validation stages pass (CVE, build, consistency, tests)

### Learning Resources

- [GitHub Copilot for VS Code](https://code.visualstudio.com/docs/copilot/overview)
- [Azure SDK for Java](https://learn.microsoft.com/azure/developer/java/sdk/)
- [Migrate from AWS to Azure](https://learn.microsoft.com/azure/architecture/aws-professional/)
- [Azure Blob Storage for Java](https://learn.microsoft.com/azure/storage/blobs/storage-quickstart-blobs-java)
- [Spring Cloud Azure](https://learn.microsoft.com/azure/developer/java/spring-framework/)
- [AppCAT Assessment Tool](https://learn.microsoft.com/azure/developer/java/migration/migration-toolkit-intro)

---

## Challenge 4 - Resolve Modernization Issues with GitHub Copilot

### Goal

Review the results of the Java application modernization and use GitHub Copilot to identify and fix any remaining issues in the migrated codebase.

### Context

The full application modernization process from Challenge 3 can take a significant amount of time to complete. To keep the workshop moving, we have already run the complete modernization ahead of time and saved the results to the `app_after_mod` branch. In this challenge, you will check out that branch, review the modernized code, and use GitHub Copilot to find and resolve any open issues.

### Actions

**Switch to the Modernized Codebase:**

1. Open a terminal in your Codespace or local development environment
2. Check out the pre-modernized branch:
   ```bash
   git checkout app_after_mod
   ```
3. Review the changes that were made during the modernization process:
   ```bash
   git log --oneline main..app_after_mod
   ```
4. Explore the modified files in the AssetManager project to understand what was migrated

**Identify Open Issues with GitHub Copilot:**

5. Open the AssetManager project in VS Code
6. Open GitHub Copilot Chat (Ctrl+Shift+I or Cmd+Shift+I on macOS)
7. Ask Copilot to analyze the modernized codebase for open issues. Use a prompt like:
   ```
   Analyze the AssetManager Java application and identify any open issues,
   compilation errors, or incomplete migration tasks that need to be resolved.
   ```
8. Review the list of issues Copilot identifies
9. Understand the severity and impact of each issue

**Fix Issues with GitHub Copilot:**

10. For each issue identified, ask Copilot to help fix it. Use prompts like:
    ```
    Fix the identified issues in the AssetManager application.
    Ensure the application compiles successfully and all tests pass.
    ```
11. Review the proposed changes before accepting them
12. Allow Copilot to apply the fixes
13. Verify the application builds successfully after each fix:
    ```bash
    cd src/AssetManager
    mvn clean compile
    ```

**Validate the Fixes:**

14. Run the full test suite to confirm all fixes are correct:
    ```bash
    mvn test
    ```
15. Review any remaining warnings or issues in the build output
16. Ask Copilot to address any remaining problems until the build is clean

### Success Criteria

- ✅ You have checked out the `app_after_mod` branch and reviewed the modernization changes
- ✅ GitHub Copilot identified open issues in the modernized codebase
- ✅ All identified issues have been resolved with Copilot's assistance
- ✅ The application compiles successfully without errors
- ✅ All tests pass after the fixes are applied

> **Note:** If you are unable to resolve the issues or run into problems during the fix process, you can check out the `app_fixed` branch which contains the fully fixed application:
> ```bash
> git checkout app_fixed
> ```

### Learning Resources

- [GitHub Copilot Chat in VS Code](https://code.visualstudio.com/docs/copilot/copilot-chat)
- [Debugging with GitHub Copilot](https://code.visualstudio.com/docs/copilot/debugging-with-copilot)
- [Spring Cloud Azure](https://learn.microsoft.com/azure/developer/java/spring-framework/)
- [Azure SDK for Java](https://learn.microsoft.com/azure/developer/java/sdk/)

---

## Challenge 5 - Deploy to Azure with Bicep Using GitHub Copilot

### Goal

Use GitHub Copilot to generate Bicep infrastructure-as-code scripts that provision the required Azure resources and deploy the modernized AssetManager application to Azure Container Apps.

### Actions

**Generate Bicep Infrastructure with GitHub Copilot:**

1. Open GitHub Copilot Chat (Ctrl+Shift+I or Cmd+Shift+I on macOS)
2. Ask Copilot to generate the Bicep deployment scripts for the application. Use a prompt like:
   ```
   Generate Bicep scripts to deploy the AssetManager Java application
   to Azure Container Apps. Include all required resources: Container Apps
   Environment, Container App, Azure Container Registry, Azure Blob Storage,
   and any supporting resources. Use managed identity for authentication
   between services.
   ```
3. Review the generated Bicep files and ensure they include:
   - Resource Group (or use existing)
   - Azure Container Registry (ACR)
   - Container Apps Environment
   - Container App with appropriate configuration
   - Azure Blob Storage account
   - Managed identity and role assignments
4. Ask Copilot to refine or adjust the scripts as needed

**Review and Customize the Bicep Scripts:**

5. Review the generated Bicep parameter files
6. Update parameter values to match your lab environment (resource group, region, naming conventions)
7. Ask Copilot to add any missing configuration, for example:
   ```
   Review the Bicep scripts and ensure environment variables for
   Azure Blob Storage connection are configured on the Container App.
   Add health probes and appropriate resource limits.
   ```

**Deploy the Infrastructure:**

8. Log in to Azure CLI if not already authenticated:
   ```bash
   az login
   ```
9. Deploy the Bicep scripts:
   ```bash
   az deployment group create \
     --resource-group <your-resource-group> \
     --template-file main.bicep \
     --parameters main.bicepparam
   ```
10. Monitor the deployment progress in the terminal
11. Troubleshoot any deployment errors with Copilot's help

**Build and Deploy the Application:**

12. Build the container image and push it to Azure Container Registry:
    ```bash
    az acr build --registry <acr-name> --image assetmanager:latest ./src/AssetManager
    ```
13. Update the Container App to use the newly built image
14. Verify the application is running by accessing the Container App URL

### Success Criteria

- ✅ Bicep scripts are generated with GitHub Copilot's assistance
- ✅ All required Azure resources are defined in the Bicep templates
- ✅ Infrastructure is successfully deployed to Azure
- ✅ The AssetManager application is containerized and pushed to ACR
- ✅ The application is running on Azure Container Apps and accessible via its URL

### Learning Resources

- [Bicep Overview](https://learn.microsoft.com/azure/azure-resource-manager/bicep/overview)
- [Azure Container Apps Bicep Reference](https://learn.microsoft.com/azure/templates/microsoft.app/containerapps)
- [Deploy Container Apps with Bicep](https://learn.microsoft.com/azure/container-apps/azure-resource-manager)
- [Azure Container Registry Build](https://learn.microsoft.com/azure/container-registry/container-registry-tutorial-quick-task)
- [Managed Identity for Container Apps](https://learn.microsoft.com/azure/container-apps/managed-identity)

---

## Challenge 6 - Enable Monitoring and Set Up SRE Agent

### Goal

Configure logging and monitoring for the deployed AssetManager application using Azure Monitor and Application Insights, and set up the SRE agent in Azure to enable AI-powered incident investigation and remediation.

### Actions

**Enable Application Insights with GitHub Copilot:**

1. Open GitHub Copilot Chat and ask it to update your Bicep scripts to include monitoring resources. Use a prompt like:
   ```
   Update the Bicep scripts to add Application Insights and a Log Analytics
   workspace for the AssetManager Container App. Enable system logs and
   configure the Container Apps Environment to send logs to Log Analytics.
   ```
2. Review the generated Bicep changes and ensure they include:
   - Log Analytics workspace
   - Application Insights resource connected to the workspace
   - Container Apps Environment configured with Log Analytics destination
3. Deploy the updated Bicep scripts:
   ```bash
   az deployment group create \
     --resource-group <your-resource-group> \
     --template-file main.bicep \
     --parameters main.bicepparam
   ```

**Configure Application-Level Logging:**

4. Ask Copilot to help configure the Java application for Application Insights integration:
   ```
   Configure the AssetManager Spring Boot application to send telemetry
   to Application Insights. Add the Application Insights Java agent and
   configure the connection string from environment variables.
   ```
5. Review and apply the application configuration changes
6. Rebuild and redeploy the application with monitoring enabled:
   ```bash
   az acr build --registry <acr-name> --image assetmanager:latest ./src/AssetManager
   ```

**Verify Monitoring is Working:**

7. Navigate to the Application Insights resource in the Azure Portal
8. Generate some traffic to the application by accessing its URL several times
9. Verify telemetry data is flowing:
   - Check **Live Metrics** for real-time request data
   - Review **Application Map** to see service dependencies
   - Examine **Failures** and **Performance** blades for baseline data
10. Open **Logs** and run a sample KQL query to confirm log ingestion:
    ```kql
    requests
    | summarize count() by resultCode
    | order by count_ desc
    ```

**Set Up the SRE Agent:**

11. Navigate to **Azure Monitor** in the Azure Portal
12. Open the **SRE agent (preview)** section
13. Configure the SRE agent:
    - Select your Application Insights resource as the monitored resource
    - Configure alert rules and incident detection thresholds
    - Enable AI-powered root cause analysis
14. Review the SRE agent capabilities:
    - Automated incident investigation
    - Root cause analysis with supporting evidence
    - Suggested remediation actions
15. Test the SRE agent by simulating an issue (e.g., sending requests to a non-existent endpoint) and reviewing the agent's analysis

### Success Criteria

- ✅ Application Insights and Log Analytics workspace are deployed via Bicep
- ✅ The AssetManager application is sending telemetry to Application Insights
- ✅ Live Metrics and Application Map show data in the Azure Portal
- ✅ KQL queries return log data from the application
- ✅ SRE agent is configured and monitoring the application

### Learning Resources

- [Application Insights Overview](https://learn.microsoft.com/azure/azure-monitor/app/app-insights-overview)
- [Application Insights for Java](https://learn.microsoft.com/azure/azure-monitor/app/opentelemetry-enable?tabs=java)
- [Container Apps Monitoring](https://learn.microsoft.com/azure/container-apps/observability)
- [Log Analytics KQL Queries](https://learn.microsoft.com/azure/azure-monitor/logs/get-started-queries)
- [Azure Monitor SRE Agent](https://learn.microsoft.com/azure/azure-monitor/agents/sre-agent)

---

## Challenge 7 - End-to-End Deployment with GitHub Actions

### Goal

Create a CI/CD pipeline using GitHub Actions that automatically builds, tests, and deploys the modernized AssetManager application to Azure Container Apps whenever changes are pushed to the repository.

### Actions

**Generate a GitHub Actions Workflow with GitHub Copilot:**

1. Open GitHub Copilot Chat and ask it to create a GitHub Actions workflow. Use a prompt like:
   ```
   Create a GitHub Actions workflow for the AssetManager Java application
   that builds the app with Maven, runs tests, builds a Docker image,
   pushes it to Azure Container Registry, deploys the Bicep infrastructure,
   and updates the Azure Container App with the new image.
   Use OpenID Connect (federated credentials) for Azure authentication.
   ```
2. Review the generated workflow file and ensure it includes the following stages:
   - **Build & Test**: Compile the application and run unit tests with Maven
   - **Container Image**: Build and push the Docker image to ACR
   - **Infrastructure**: Deploy Bicep templates to provision/update Azure resources
   - **Deploy**: Update the Container App with the new image
3. Save the workflow file to `.github/workflows/deploy.yml`

**Configure Azure Credentials for GitHub Actions:**

4. Ask Copilot how to set up OpenID Connect between GitHub Actions and Azure:
   ```
   How do I create a federated credential in Microsoft Entra ID for
   GitHub Actions to authenticate with Azure using OpenID Connect?
   ```
5. Create an App Registration in Microsoft Entra ID
6. Add a federated credential for your GitHub repository
7. Assign the required roles (Contributor, AcrPush) to the App Registration on your resource group
8. Add the following secrets to your GitHub repository (Settings → Secrets and variables → Actions):
   - `AZURE_CLIENT_ID`
   - `AZURE_TENANT_ID`
   - `AZURE_SUBSCRIPTION_ID`

**Customize and Refine the Workflow:**

9. Review the workflow triggers and ensure it runs on pushes to the `main` branch:
   ```yaml
   on:
     push:
       branches: [main]
     workflow_dispatch:
   ```
10. Ask Copilot to add environment variables and parameterize resource names:
    ```
    Update the workflow to use GitHub Actions variables for the resource
    group name, ACR name, and Container App name so they are easy to change.
    ```
11. Commit and push the workflow file to your repository

**Run and Validate the Pipeline:**

12. Trigger the workflow manually using the **workflow_dispatch** event or push a change to the `main` branch
13. Navigate to the **Actions** tab in your GitHub repository to monitor the workflow run
14. Review each job and step for successful completion
15. If a step fails, use Copilot to help troubleshoot:
    ```
    The GitHub Actions workflow failed at the deploy step with the following
    error: <paste error message>. How do I fix this?
    ```
16. Verify the deployed application is running by accessing the Container App URL
17. Make a small change to the application code, push it, and confirm the pipeline deploys the update automatically

### Success Criteria

- ✅ A GitHub Actions workflow file is created with Copilot's assistance
- ✅ Azure credentials are configured using OpenID Connect (federated credentials)
- ✅ The pipeline builds the application and runs tests successfully
- ✅ The container image is built and pushed to Azure Container Registry
- ✅ Bicep infrastructure is deployed as part of the pipeline
- ✅ The application is deployed to Azure Container Apps and accessible via its URL
- ✅ Subsequent code pushes automatically trigger a new deployment

### Learning Resources

- [GitHub Actions Documentation](https://docs.github.com/actions)
- [Deploy to Azure Container Apps with GitHub Actions](https://learn.microsoft.com/azure/container-apps/github-actions)
- [Azure Login with OpenID Connect](https://learn.microsoft.com/azure/developer/github/connect-from-azure-openid-connect)
- [GitHub Actions for Azure](https://learn.microsoft.com/azure/developer/github/github-actions)
- [Bicep Deployment in CI/CD](https://learn.microsoft.com/azure/azure-resource-manager/bicep/deploy-github-actions)

---

