# HelloID-Task-SA-Target-ActiveDirectory-AccountMove
####################################################
# Form mapping
$formObject = @{
    UserIdentity     = $form.UserIdentity
    TargetOu         = $form.TargetOu
}

try {
    Write-Information "Executing ActiveDirectory action: [MoveAccount] for: [$($formObject.UserIdentity)]"

    Import-Module ActiveDirectory -ErrorAction Stop

    $adUser = Get-ADUser -Filter "userPrincipalName -eq '$($formObject.UserIdentity)'"
    if ($adUser) {

        $null = Move-ADObject -Identity $adUser -TargetPath $formObject.TargetOu
        $auditLog = @{
            Action            = 'MoveAccount'
            System            = 'ActiveDirectory'
            TargetIdentifier  = "$($adUser.SID.value)"
            TargetDisplayName = "$($formObject.UserIdentity)"
            Message           = "ActiveDirectory action: [MoveAccount] for: [$($formObject.UserIdentity)] executed successfully"
            IsError           = $false
        }
        Write-Information -Tags 'Audit' -MessageData $auditLog
        Write-Information "ActiveDirectory action: [MoveAccount] for: [$($formObject.UserIdentity)] executed successfully"
    } else {
        Write-Error "ActiveDirectory action: [MoveAccount] for: [$($formObject.UserIdentity)] cannot execute. The account cannot be found in the AD."
    }
} catch {
    $ex = $_
    $auditLog = @{
        Action            = 'MoveAccount'
        System            = 'ActiveDirectory'
        TargetIdentifier  = "$($adUser.SID.value)"
        TargetDisplayName = "$($formObject.UserIdentity)"
        Message           = "Could not execute ActiveDirectory action: [MoveAccount] for: [$($formObject.UserIdentity)], error: $($ex.Exception.Message)"
        IsError           = $true
    }
    Write-Information -Tags "Audit" -MessageData $auditLog
    Write-Error "Could not execute ActiveDirectory action: [MoveAccount] for: [$($formObject.UserIdentity)], error: $($ex.Exception.Message)"
}
####################################################
