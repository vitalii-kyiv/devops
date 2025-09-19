# Load environment variables from .env file
param(
    [string]$EnvFile = ".env"
)

if (Test-Path $EnvFile) {
    Write-Host "Loading environment variables from $EnvFile" -ForegroundColor Green
    
    Get-Content $EnvFile | ForEach-Object {
        if ($_ -match '^([^#][^=]+)=(.*)$') {
            $name = $matches[1].Trim()
            $value = $matches[2].Trim()
            
            # Remove quotes if present
            if ($value -match '^"(.*)"$' -or $value -match "^'(.*)'$") {
                $value = $matches[1]
            }
            
            [Environment]::SetEnvironmentVariable($name, $value, "Process")
            Write-Host "Set $name" -ForegroundColor Yellow
        }
    }
} else {
    Write-Host "Environment file $EnvFile not found. Using defaults." -ForegroundColor Yellow
}

Write-Host "Environment variables loaded!" -ForegroundColor Green
