# Active Directory User Creation and Placement

Active Directory is a Microsoft service at the heart of network management, enabling the organization and secure access of user accounts, computers, and resources within a corporation's Windows network environment. 

## Prerequisites 

Before running AD scripts you must first have an Active Directory server. Here is a tutorial on how to set up an office network with an Active Directory server and computers using virtual machines and virtual adapters:

[Host Active Directory With Virtual Machines](https://www.youtube.com/watch?v=MHsI8hJmggI)


## Using the Create User Script

The [*user_creating_script.ps1*](https://github.com/Ammmmmmmmmmmmmmmm/Active-Directory-User-Manipulation/blob/main/user_creating_script.ps1) will create 1000 randomly generated users from [*userlist.csv*](https://github.com/Ammmmmmmmmmmmmmmm/Active-Directory-User-Manipulation/blob/main/userlist.csv) and add them to the Active Directory domain. This means that all office computers registered in the domain will be able to be logged in by any user added to the Active Directory. To run the script open up a terminal with **IN ADMINISTRATOR MODE** and change the working directory to where the script and csv are stored.

```powershell
cd C:\Users\a-meave\Desktop\Active_Directory_User_Creation
.\user_creating_script.ps1
```
### Output should look like this:

### Other Script Functions

* Creates Organizational Units for each city (Houston, etc.) and places users accordingly
* Creates Security Groups (PowerUser, etc.) and assigns to each user by job title
* Robust error Handling with informative error messages
* Creates a log file of script runtime events 



## License

[MIT](https://choosealicense.com/licenses/mit/)