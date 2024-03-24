<#
.SYNOPSIS
A companion tool that uses ADeleg to find insecure trustee and resource delegations in Active Directory.

.DESCRIPTION
ADeleginator finds insecure Active Directory delegations by
    1) Running ADeleg.exe and creating a csv report
    2) Reads the csv report to find common insecure delegations
    3) Creates a report containing only the insecure delegations

.EXAMPLE
Invoke-ADeleginator

.EXAMPLE
Invoke-ADeleginator -PathToADeleg 'C:\Tools\ADeleg.exe'

#>
function Invoke-ADeleginator {
    [CmdletBinding()]
    Param(
        $PathToADeleg,
        $Server
    )

    # Create ADeleg csv or json report in the current directory
    function Create-ADelegReport{
        [CmdletBinding()]
        Param(
            $PathToADeleg,
            $ReportName
        )

        if ($Server) {
            try {
                & $PathToADeleg --server $Server --csv "ADelegReport_$(Get-Date -Format ddMMyyyy).csv"
            } catch {}
        } else {
            try {
                & $PathToADeleg --csv "ADelegReport_$(Get-Date -Format ddMMyyyy).csv"
            } catch {}
        }
    }

    # find insecure trustee delegations
    function Find-InsecureTrusteeDelegations{
        [CmdletBinding()]
        Param(
            $ADelegReport,
            $UnsafeTrustees,
            $UnsafeDelegations
        )

        foreach ($Entry in $ADelegReport) {
            if ($Entry.Trustee -match $UnsafeTrustees -and $Entry.Category -match "Allow" `
                -and $Entry.Details -match $UnsafeDelegations) {
                $InsecureTrusteeDelegations = [pscustomobject]@{
                    Trustee = $Entry.Trustee
                    TrusteeType = $Entry.'Trustee Type'
                    Resource = $Entry.Resource
                    Category = $Entry.Category
                    Delegations = $Entry.Details
                }
                $InsecureTrusteeDelegations
            }
        }
    }

    # find insecure resource delegations
    function Find-InsecureResourceDelegations {
        [CmdletBinding()]
        Param(
            $ADelegReport, 
            $UnsafeTrustees, 
            $Tier0Resources, 
            $UnsafeDelegations
        )

        foreach ($Entry in $ADelegReport) {
            if ($Entry.Trustee -match $UnsafeTrustees  -and $Entry.Resource -match $Tier0Resources `
                -and $Entry.Category -match "Allow" -and $Entry.Details -match $UnsafeDelegations) {
                $InsecureResourceDelegations = [pscustomobject]@{
                    Trustee = $Entry.Trustee
                    TrusteeType = $Entry.'Trustee Type'
                    Resource = $Entry.Resource
                    Category = $Entry.Category
                    Delegations = $Entry.Details
                }
                $InsecureResourceDelegations
            }
        }
    }

    $UnsafeTrustees = 'Domain Users|Authenticated Users|Everyone'
    $Tier0Resources = 'Account Operators|Administrator|Administrators|AdminSDHolder|Backup Operators|Cryptographic Operators|Distributed COM Users|Domain Admins|Domain Controllers|Domain Controllers (OU)|Domain root object|DnsAdmins|Enterprise Admins|GPO linked to Tier Zero container|krbtgt|Print Operators|RODC computer object|Schema Admins|Server Operators|Users (container)'
    $UnsafeDelegations = 'owns|write all properties|create child objects|delete child objects|Change the owner|add/delete delegations|delete'

    $PathToADeleg = '.\ADeleg.exe'
    $ReportName = "ADelegReport_$(Get-Date -Format ddMMyyyy).csv"

    #ASCII!
    Write-Host @"

          Go, go ADeleginator!

              .'|
             |  |  _ _
             |  | (_X_)
             |  |   |
              ``.|_.-"-._
                |.-"""-.|
               _;.-"""-.;_
           _.-' _..-.-.._ '-._
          ';--.-(_o_I_o_)-.--;'
           ``. | |  | |  | | .``
             ``-\|  | |  |/-'
                |  | |  |
                |  \_/  |
             _.'; ._._. ;'._
        _.-'``; | \  -  / | ;'-.
      .' :  /  |  |   |  |  \  '.
     /   : /__ \  \___/  / __\ : ``.
    /    |   /  '._/_\_.'  \   :   ``\
   /     .  ``---;"""""'-----``  .     \
  /      |      |()    ()      |      \
 /      /|      |              |\      \
/      / |      |()    ()      | \      \
|         |
\     \  | ][     |   |    ][  |  /     /
 \     \ ;=""====='"""'====""==; /     /
  |/``\  \/      |()    ()      \/  /``\|
   |_/.-';      |              |``-.\_|
     /   |      ;              :   \
     |__.|      |              |.__|
         ;      |              |
         |      :              ;
         |      :              |
         ;      |              |
         ;      |              ;
         |      :              |
         |      |              ;
         |      |              ;
         '-._   ;           _.-'
             ``;"--.....--";``
              |    | |    |
              |    | |    |
              |    | |    |
              T----T T----T
         _..._L____J L____J _..._
       .`` "-. ``%   | |    %`` .-" ``.
      /      \    .: :.     /      \
      '-..___|_..=:`` ``-:=.._|___..-'
diddle by VK

____ ___  ____ _    ____ ____ _ _  _ ____ ___ ____ ____ 
|__| |  \ |___ |    |___ | __ | |\ | |__|  |  |  | |__/ 
|  | |__/ |___ |___ |___ |__] | | \| |  |  |  |__| |  \ 
                                                        
by: Spencer Alessi @techspence                     v0.1

"@

    if (Get-Item $PathToADeleg -ErrorAction SilentlyContinue) {
        #continue
    } else {
        Write-Warning "ADeleg not found in the current directory. Download and place ADeleg.exe in the same folder as this script, then run ADeleginator again."
        Write-Warning "You can download ADeleg from here: https://github.com/mtth-bfft/adeleg/releases"
        break;
    }

    Write-Host "[i] Running ADeleg and creating $ReportName"

    Create-ADelegReport -PathToADeleg $PathToADeleg -ReportName $ReportName

    $ADelegReport = Import-Csv -Path $ReportName

    Write-Host "[i] Checking for insecure trustee/resource delegations..."

    $InsecureTrusteeDelegations = Find-InsecureTrusteeDelegations -ADelegReport $ADelegReport -UnsafeTrustees $UnsafeTrustees -UnsafeDelegations $UnsafeDelegations

    $InsecureResourceDelegations = Find-InsecureResourceDelegations -ADelegReport $ADelegReport -UnsafeTrustees $UnsafeTrustees -Tier0Resources $Tier0Resources -UnsafeDelegations $UnsafeDelegations

    if ($InsecureTrusteeDelegations) {
        Write-Host "[!] Insecure trustee delegations found. Exporting report: ADeleg_InsecureTrusteeDelegationReport_$(Get-Date -Format ddMMyyyy).csv" -ForegroundColor Red
        $InsecureTrusteeDelegations | Export-Csv ADeleg_InsecureTrusteeDelegationReport_$(Get-Date -Format ddMMyyyy).csv -NoTypeInformation
    } else {
        Write-Host "[+] No insecure trustee delegations found. Eureka!" -ForegroundColor Green
    }

    if ($InsecureResourceDelegations) {
        Write-Host "[!] Insecure resource delegations found. Exporting report: ADeleg_InsecureResourceDelegationReport_$(Get-Date -Format ddMMyyyy).csv" -ForegroundColor Red
        $InsecureResourceDelegations | Export-Csv ADeleg_InsecureResourceDelegationReport_$(Get-Date -Format ddMMyyyy).csv -NoTypeInformation
    } else {
        Write-Host "[+] No insecure resource delegations found. Eureka!" -ForegroundColor Green
    }

    Write-Host "`n`nThank you for using ADeleginator. Godspeed! :O)`n"
}