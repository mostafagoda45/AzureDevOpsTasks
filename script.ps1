$tasksToDownload = @("DownloadSecureFile")

$pat = "ct5diwm7q7o2b3j7w66zwmpaufatmjparzmvm4zaguryhfukp4rq"

$url = "https://taw-devops.mostafagoda.com/DefaultCollection"
$header = @{authorization = "Basic $([Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(".:$pat")))"}

$tasks = Invoke-RestMethod -Uri "$url/_apis/distributedtask/tasks" -Method Get -ContentType "application/json" -Headers $header
