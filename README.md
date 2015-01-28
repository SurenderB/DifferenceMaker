# DifferenceMaker

## Database


## Source Code
After downloading the source:

* Enable Package Restore on the solution (right-click solution and select Enable Package Restore)
* Build the solution to confirm it builds successfully
* Within the UI folder
 * Open the Web.config file for the DifferenceMaker.AdminUI project and modify the settings within the <AppSettings> element to match your environment/needs.
 * Set the DifferenceMaker.AdminUI project as the Startup Project
 * Set index.html as the Start Page
* Within the Services folder
 * Open the Web.config file for the DifferenceMaker.WebAPI project and modify the connection string to match the database name created above
