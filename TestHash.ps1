$param1=$args[0]
$param2=$args[1]

# Retrieve all files directly located within any directory like C:\Windows directory and compute a hash value for each.
$WindowsExesOnly = Get-ChildItem $param1* | 
Select-Object -Property *,
@{name="Hash";expression={(Get-FileHash $_.FullName -Algorithm MD5).hash}}

# Retrieve all files located in any directory , but not recursively, and compute a hash value for each.
$SecondLevelExes = Get-ChildItem $param2* | 
Select-Object -Property *,
@{name="Hash";expression={(Get-FileHash $_.FullName -Algorithm MD5).hash}}
$EmailBody = Compare-Object -Ref $WindowsExesOnly -Dif $SecondLevelExes -Property Name,Hash -PassThru | Select-Object SideIndicator,FullName
if ($EmailBody.passwordlastset -eq $null){$EmailBody ="Matched , WellDone"}
