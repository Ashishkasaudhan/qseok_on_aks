# This Powershell will call "kubectl delete pod" for a given list of pods
# (...typically after deletion they will be restarted by the deployment object ...)
# Provide the list of pod name fragments as command line arguments, separated by space
# Each entry is matched as "pod name >contains< entry", not the exact name
# example: ./delete_pods.ps1 auth sess group

if ($args.count -eq 0) {
  echo "No arguments provided. Give a space-separated list of (fragments of) pod names."
} else {
  $podlist = $args -join "|"
  Write-Host "Deleting pods $podlist ..."
  $getpods = kubectl get pod -o=custom-columns=n:.metadata.name | Select-String "(?:$podlist)" 
  ForEach ($pod in ($getpods -split ("`r") -split ("`n")))
  {
    If ($pod.length -gt 0) { kubectl delete pod $pod }
  }
}
