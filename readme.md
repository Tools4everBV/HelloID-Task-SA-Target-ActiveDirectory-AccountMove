
# HelloID-Task-SA-Target-ActiveDirectory-AccountMove

## Prerequisites

- [ ] The HelloID SA on-premises agent installed

- [ ] The ActiveDirectory module is installed on the server where the HelloID SA on-premises agent is running.

## Description

This code snippet executes the following tasks:

This code snippet will move a user from Active Directory to a specified organizational unit and executes the following tasks:

1. Define a hash table `$formObject`. The keys of the hash table represent the properties of the `Get-ADUser` cmdlet, while the values represent the values entered in the form.

> To view an example of the form output, please refer to the JSON code pasted below.

```json
{
    "UserIdentity": "testuser@mydomain.local",
    "TargetOu" : "OU=ou2,OU=development,DC=mydomain,DC=local"
}
```

> :exclamation: It is important to note that the names of your form fields might differ. Ensure that the `$formObject` hashtable is appropriately adjusted to match your form fields.
> The field **UserIdentity** accepts different values [See the Microsoft Docs page](https://learn.microsoft.com/en-us/powershell/module/activedirectory/move-adobject?view=windowsserver2022-ps#description)

2. Imports the ActiveDirectory module.

3. Verifies that the account that must be deleted exists based on the `UserIdentity` using the `Get-ADUser` cmdlet.

4. If the user does exist, the account is moved using the `Move-ADObject` cmdlet, otherwise an warning is generated.
