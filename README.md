# ADeleginator
A tool to find insecure trustee and resource delegations in Active Directory

```
____ ___  ____ _    ____ ____ _ _  _ ____ ___ ____ ____ 
|__| |  \ |___ |    |___ | __ | |\ | |__|  |  |  | |__/ 
|  | |__/ |___ |___ |___ |__] | | \| |  |  |  |__| |  \ 
                                                        
by: Spencer Alessi @techspence                     v0.1

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
            ``. |  | |  |  .``
            ``-\|  | |  |/-'
                |  | |  |
                |  \_/  |
             _.'; ._._. ;'._
        _.-'`; | \  -  / | ;'-.
      .' :  /  |  |   |  |  \  '.
     /   : /__ \  \___/  / __\ : ``.
    /    |   /  '._/_\_.'  \   :  ``\
   /     .  ``---;"""""'-----``.     \
  /      |      |()    ()      |      \
 /      /|      |              |\      \
/      / |      |()    ()      | \      \
\     \  | ][     |   |    ][  |  /     /
 \     \ ;=""====='"""'====""==; /     /
  |/``\  \/     |()    ()      \/ /``\|
   |_/.-';      |              |`-.\_|
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
         _..._L____J L____J_..._
       .`` "-. ``% | | %`` .-" ``.
      /      \    .: :.    /      \
      '-..___|_..=:` `-:=.._|___..-'
diddle by VK
```

# How to run
1. Copy `Invoke-ADeleginator.ps1` to your system or `git clone https://github.com/techspence/ADeleginator`
2. Download [ADeleg.exe](https://github.com/mtth-bfft/adeleg/releases) and place it in the same folder as `Invoke-ADeleginator`
3. Open PowerShell, navigate to the location of `Invoke-ADeleginator.ps1` and dot source it using: `. .\Invoke-ADeleginator.ps1`
4. Run with: `Invoke-ADeleginator`
