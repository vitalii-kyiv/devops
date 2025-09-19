param(
  [string]$Workspace = "devops"
)

Write-Host "[mock] Terraform init/validate/plan in $PWD" -ForegroundColor Cyan

if (-not (Test-Path -Path "state")) { New-Item -ItemType Directory -Path "state" | Out-Null }

terraform init -input=false
if ($LASTEXITCODE -ne 0) { throw "terraform init failed" }

terraform validate
if ($LASTEXITCODE -ne 0) { throw "terraform validate failed" }

terraform plan -out tfplan -input=false
if ($LASTEXITCODE -ne 0) { throw "terraform plan failed" }

Write-Host "[mock] Plan complete → tfplan" -ForegroundColor Green


