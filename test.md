# Testing Setup on a New User Account

To simulate a completely new Windows machine without any installed software, you can create a new local user account, switch to it, and run `setup.ps1`. This tests the script as if on a fresh machine.

## Create a New Test User
Run these commands in PowerShell with Administrator privileges:

1. Create the user (password is set to "00" for simplicity; change if needed):
   ```
   New-LocalUser -Name "TestUser" -Password (ConvertTo-SecureString "00" -AsPlainText -Force) -FullName "Test User" -Description "Test account for setup simulation"
   ```

2. Add to Users group:
   ```
   Add-LocalGroupMember -Group "Users" -Member "TestUser"
   ```

## Switch to the New User
- Log out of the current user.
- On the login screen, select "TestUser" and log in with password "00".

## Test the Setup
1. Open a browser (e.g., Edge), go to GitHub, and clone this repo.
2. Open PowerShell (enable script execution if needed).
3. Run: `.\setup.ps1`
4. Check `error.log` for results.

## Remove the Test User
After testing, switch back to your main user and run this in PowerShell with Administrator privileges:
```
Remove-LocalUser -Name "TestUser"
```

**Note:** This removes the user and their profile. Ensure no important data is left in the test user.