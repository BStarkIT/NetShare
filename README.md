# NetShare
Simple network share maker

This script creates a share on a local machine and maps it to a remote machine. 
It is designed to be run on two machines to create a share between them.
The first run will create the config file. Run on the second machine to add the second machine to the config file.
Once the config file is complete, copy it to the first machine and run the script on both machines to create the share.
The shares will be mapped as the Z drive on the other PC.

I have included the PowerShell source file as well as the exe. you only need to run one version.

# Instructions
Run the exe on PC 1
This will make the folder C:\NetShare\ & Tempconfig.csv
edit the Tempconfig.csv to the Password & Username 
the file will show
![image](https://github.com/user-attachments/assets/8b9cfb85-2849-4677-9f1f-80b717c9ec86)
or
![image](https://github.com/user-attachments/assets/1154679a-e619-44e4-814a-0f254565e827)
If you use Excel
Change the User Name & Password and copy the file to the 2nd pc.
Run the tool on the 2nd PC then replace the Tempconfig.csv file from the one edited and saved on PC1.
Run a second time on PC2 & you will now have config.csv
Copy this BACK to PC1 and run on both.
A Local user will be created and the folder will be shared.
press return when both computers are at the same point to complete.
the share from the other PC will now be mapped as the Z: drive of the pc.


