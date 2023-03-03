# HelloID-Task-SA-Target-ActiveDirectory-AccountMove
####################################################
# Form mapping
$formObject = @{
    UserPrincipalName     = $form.UserPrincipalName
    TargetOu              = $form.TargetOu
}

try {
    Write-Information "Executing ActiveDirectory action: [MoveAccount] for: [$($formObject.UserPrincipalName)]"

    Import-Module ActiveDirectory -ErrorAction Stop

    $adUser = Get-ADUser -Filter "userPrincipalName -eq '$($formObject.UserPrincipalName)'"
    if ($adUser) {

        $null = Move-ADObject -Identity $adUser -TargetPath $formObject.TargetOu
        $auditLog = @{
            Action            = 'MoveAccount'
            System            = 'ActiveDirectory'
            TargetIdentifier  = "$($adUser.SID.value)"
            TargetDisplayName = "$($formObject.UserPrincipalName)"
            Message           = "ActiveDirectory action: [MoveAccount] for: [$($formObject.UserPrincipalName)] executed successfully"
            IsError           = $false
        }
        Write-Information -Tags 'Audit' -MessageData $auditLog
        Write-Information "ActiveDirectory action: [MoveAccount] for: [$($formObject.UserPrincipalName)] executed successfully"
    } else {
        Write-Error "ActiveDirectory action: [MoveAccount] for: [$($formObject.UserPrincipalName)] cannot execute. The account cannot be found in the AD."
    }
} catch {
    $ex = $_
    $auditLog = @{
        Action            = 'MoveAccount'
        System            = 'ActiveDirectory'
        TargetIdentifier  = "$($adUser.SID.value)"
        TargetDisplayName = "$($formObject.UserPrincipalName)"
        Message           = "Could not execute ActiveDirectory action: [MoveAccount] for: [$($formObject.UserPrincipalName)], error: $($ex.Exception.Message)"
        IsError           = $true
    }
    Write-Information -Tags "Audit" -MessageData $auditLog
    Write-Error "Could not execute ActiveDirectory action: [MoveAccount] for: [$($formObject.UserPrincipalName)], error: $($ex.Exception.Message)"
}
####################################################
