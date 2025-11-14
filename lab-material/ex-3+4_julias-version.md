
# Excercise 3 - .NET App modernization

Let us get our hands dirty on some code.

We want to use GitHub Copilot to modernize our .NET application. To achieve that we have two options.

## 1) Using Visual Studio

You can install an extension that is called *GitHub Copilot app modernization*. This extension uses a dedicated agent inside GitHub Copilot to help you upgrade this project to a newer .NET version and will afterwards support you with the migration to Azure.

With this extension you can:

* Upgrade to a newer version of .NET
* Migrate technologies and deploy to Azure
* Modernize your .NET app, especially when upgrading from .NET Framework
* Assess your application's code, configuration, and dependencies
* Plan and set up the right Azure resource
* Fix issues and apply best practices for cloud migration
* Validate that your app builds and tests successfully

## 2) Using Visual Studio Code

You can use GitHub Copilot agent mode to modernize your .NET application and deploy it to Azure.

Choose your path :)

===

# 3.1 Clone the repository

The first target application we will migrate is *Contoso University*.

If you are not logged in already, log in to GitHub and open the [link to the repository](https://github.com/crgarcia12/migrate-modernize-lab "link to the repository").

Fork your own copy of the repository. On the upper right click on the fork dropdown and then on *Create a new fork*.

!IMAGE[Screenshot 2025-11-14 at 10.16.45.png](instructions310257/Screenshot 2025-11-14 at 10.16.45.png)

Ensure you are the Owner and give your repository a new name or keep *migrate-modernize-lab* and click on *Create fork*. In a few seconds you should be able to see your forked repository in your GitHub account.

!IMAGE[Screenshot 2025-11-14 at 10.17.19.png](instructions310257/Screenshot 2025-11-14 at 10.17.19.png)

## 1) Visual Studio

1. Open Visual Studio  
2. Select Clone a repository  
3. Go back to GitHub to your forked repository. Click on *Code* and in the tab *Local* choose *HTTPS* and *Copy URL to clipboard*. Paste your repository link in the **Repository Location**  
   > The URL should look something like this: *https://github.com/your_handle/your_repo_name.git*

   !IMAGE[Screenshot 2025-11-14 at 10.42.04.png](instructions310257/Screenshot 2025-11-14 at 10.42.04.png)

4. Click Clone and wait a moment for the cloning to finish

5. Let us open the app  
   1. In the menu select File and then Open  
   2. Navigate to **migrate-modernize-lab**, **src**, **Contoso University**  
   3. Find the file **ContosoUniversity.sln**  
   4. In the View menu click *Solution Explorer*  
   5. Rebuild the app
   
   TODO: add more screenshots
  
> TODO The build fails? Make sure all Nuget.org packages are installed. (insert how to do this)

It is not required for the lab, but if you want you can run the app in IIS Express (Microsoft Edge).

!IMAGE[0030.png](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0030.png)

Edge will open and you will see the application running at `https://localhost:44300`

## 2) Visual Studio Code

1. Go back to GitHub to your forked repository. Click on *Code* and in the tab *Local* choose *HTTPS* and *Copy URL to clipboard*.  
2. Open Visual Studio Code  
3. In the navigation bar on the left select *Source Control* and *Clone Repository*  
4. Paste your repository link in the input field and select *Clone from URL*. Select your local repository destination, wait a moment for the cloning to finish, and when the dialog appears click on *Open*.  
   > The URL should look something like this: *https://github.com/your_handle/your_repo_name.git*

!IMAGE[Screenshot 2025-11-14 at 10.57.23.png](instructions310257/Screenshot 2025-11-14 at 10.57.23.png)
!IMAGE[Screenshot 2025-11-14 at 11.01.31.png](instructions310257/Screenshot 2025-11-14 at 11.01.31.png)

5. The just cloned project opens in VS Code

> The project as it is cannot be run out of VS Code in this state.

===

# 3.2 Code assessment

Before we can start with the modernization itself we need to run an assessment to understand the application's technical foundation, dependencies, and the implemented business logic.

## 1) Visual Studio

The first step is to do a code assessment. For that we will use the *GitHub Copilot app modernization* extension.

TODO: check if it is preinstalled or if we need another step to install it and if we are already logged in to GitHub

1. Right click in the project and select *Modernize*

!IMAGE[0040.png](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0040.png)

TODO: add descriptions of what happens next

## 2) Visual Studio Code

1. In the navigation bar on the left select *Extensions* and install *GitHub Copilot* and *GitHub Copilot Chat*.
2. Open the GitHub Copilot Chat. A popup will appear asking you to sign in to GitHub. Follow the steps to sign in.
TODO: add credentials! 
3. Select Agent mode and the model of your choice  
   > We recommend Claude Sonnet 4 or 4.5.

4. Use this initial prompt to start the assessment step:

   *I would like to modernize this .NET application to .NET 9. Assess this project and tell me about the technical foundation, dependencies that need to be updated, and give me a brief summary of the implemented business logic and everything else you think is relevant for a modernization. Save the assessment results in an assessment.md in the workspace's root folder. Do not make any code changes yet.*

5. Wait until GitHub Copilot is done and have a look at the *assessment.md*. Results may vary. If you are for any reason not happy with the results, you have multiple options:

   a) Open a new GitHub Copilot chat (you can click plus on top of the chat window) and run the initial prompt again, but change the file name to *assessment1.md* (or something similar). After the second assessment run is done, ask GitHub Copilot to compare both documents and fact check itself. An example prompt could be:

   *Check the assessment.md and assessment1.md files and compare them. If there are significant differences, check again with the code base and reevaluate the results. Merge all important information into one assessment.md and delete the other file.*

**OR**

   b) Open a new GitHub Copilot chat (you can click plus on top of the chat window). Delete the *assessment.md* and iterate on the initial prompt yourself so that GitHub Copilot understands better what you want to learn about this problem, then run the assessment again.

If you are happy with the assessment results, continue with the next step of the lab.

===

# 3.3 Upgrade the app to .NET 9

Next step is to upgrade the application to .NET 9 and update the outdated dependencies and packages as they are known to have security vulnerabilities.

## 1) Visual Studio
1. Right click in the project and select *Modernize*
2. Click *Accept upgrade settings and continue*

!IMAGE[0050.png](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0050.png)

Let s review copilot proposal

TODO: Point to some details

3. Review the proposed plan.
4. Ask what is the most risky part of the upgrade
5. Ask if there are security vulnerabilities in the current solution
6. Ask copilot to perform the upgrade
7. Try to clean and build the solution
8. If there are erros, tell copilot to fix the errors using the chat
9. Run the application again, this time as a standalone DotNet application

!IMAGE[0060.png](https://raw.githubusercontent.com/crgarcia12/migrate-modernize-lab/refs/heads/main/lab-material/media/0060.png)

> [!Hint] If you see an error at runtime. Try asking copilot to fix it for you.
>
> For example, you can paste the error message and let Copilot fix it. For example: `SystemInvalidOperation The ConnectionString has not been initialized.` 

TODO: See the lists of commit, if we managed to fork the repo

## 2) Visual Studio Code

