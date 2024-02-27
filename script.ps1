$tasksToDownload = @("DownloadSecureFile")

$pat = "ct5diwm7q7o2b3j7w66zwmpaufatmjparzmvm4zaguryhfukp4rq"

$url = "https://taw-devops.mostafagoda.com/DefaultCollection"
$header = @{authorization = "Basic $([Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(".:$pat")))"}

$tasks = Invoke-RestMethod -Uri "$url/_apis/distributedtask/tasks" -Method Get -ContentType "application/json" -Headers $header | ConvertFrom-Json -AsHashtable

foreach ($taskName in $tasksToDownload)
{
    $taskMetadatas = $tasks.value | ?{ $_.name -ieq $taskName }
    foreach ($taskMetadata in $taskMetadatas)
    {
        $taskid = $taskMetadata.id
        $taskversion = "$($taskMetadata.version.major).$($taskMetadata.version.minor).$($taskMetadata.version.patch)"
        $taskZip = "$taskName.$taskid.$taskversion.zip"
        Invoke-WebRequest -Uri "$url/_apis/distributedtask/tasks/$taskid/$taskversion" -OutFile $taskZip -Headers $header

        & tfx build tasks upload --task-zip-path "$taskZip" --service-url $projectCollectionUri
    }
}
