# 查找所有 Visual Studio 实例
$vsInstances = & "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" -all -format json | ConvertFrom-Json

if ($vsInstances.Count -eq 0) {
    Write-Output "未找到已安装的 Visual Studio 实例。"
    exit 0
}

# 逐个卸载
foreach ($instance in $vsInstances) {
    $installPath = $instance.installationPath
    $productId = $instance.productId
    Write-Output "正在卸载: $productId"
    
    # 静默卸载（不重启）
    & "$installPath\Installer\setup.exe" uninstall --productId $productId --passive --norestart
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "卸载失败: $productId (错误码: $LASTEXITCODE)"
    }
}

Write-Output "所有 Visual Studio 实例已卸载。"
