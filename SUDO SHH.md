Generate SSH Key Pair on Windows (PuTTYgen):

Open PuTTYgen on your Windows machine.
Click on the "Generate" button to create a new SSH key pair.
Follow the instructions to move your mouse around the blank area to generate randomness for the key.
Once the key pair is generated, you'll see the public key displayed in the PuTTYgen window. Save both the public and private keys to your Windows machine.
Copy the Public Key:

Open the public key file (your_windows_public_key.pub) using a text editor or PuTTYgen.
Select and copy the entire content of the public key.
Add Public Key to Ubuntu Server:

Connect to your Ubuntu server using SSH.
Once logged in, navigate to the .ssh directory in your home directory (/home/your_username/.ssh/). If the directory doesn't exist, you can create it.
Open or create the authorized_keys file in the .ssh directory using a text editor like nano or vi.
Paste the content of the public key file (your_windows_public_key.pub) into the authorized_keys file and save it.
Ensure correct file permissions for .ssh directory (700) and authorized_keys file (600).
Open the sshd_config File:

bash
Copy code
sudo nano /etc/ssh/sshd_config
Locate the PubkeyAcceptedAlgorithms Option:
Use the arrow keys to navigate through the file until you find the line starting with PubkeyAcceptedAlgorithms.

Modify the PubkeyAcceptedAlgorithms Option:
Add ssh-rsa to the list of accepted algorithms. Ensure that the line looks similar to the following (you may need to adjust it based on your specific configuration):

Copy code
PubkeyAcceptedAlgorithms ssh-rsa,ssh-dss,ecdsa-sha2-nistp256,ecdsa-sha2-nistp384,ecdsa-sha2-nistp521,ssh-ed25519
Save and Exit:
Press Ctrl + X to exit Nano, then press Y to confirm saving the changes, and press Enter to confirm the filename.

Restart the SSH Server:

Copy code
sudo systemctl restart ssh
After following these steps, the SSH server on your Ubuntu machine should accept RSA keys (ssh-rsa) for authentication. You can then attempt to connect to the server using SSH from your client machine again.

Configure PuTTY Session:

Open PuTTY on your Windows machine.
In the PuTTY Configuration window:
Enter the IP address or hostname of your Ubuntu server in the "Host Name (or IP address)" field.
Navigate to Connection -> SSH -> Auth.
In the "Private key file for authentication" field, browse and select the private key file (.ppk) generated by PuTTYgen.
Navigate to Connection -> Data.
In the "Auto-login username" field, enter the username of the sudo user on the Ubuntu server.
Save the PuTTY session settings for future use if desired.
Connect with PuTTY:

Click "Open" to establish the SSH connection.
PuTTY will automatically log in to the Ubuntu server using the specified username and private key.
Since the specified username is a sudo user, you'll have sudo privileges once logged in.
