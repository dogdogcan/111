# 查找所有 Visual Studio 实例
$vsInstances = & "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe" -all -format json | ConvertFrom-Json

if ($vsInstances.Count -eq 0) {
    Write-Output "未找到已安装的 Visual Studio 实例。"
    exit 0
}

# 获取全局 Visual Studio Installer 路径
$installerPath = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\setup.exe"

# 检查安装程序是否存在
if (-not (Test-Path $installerPath)) {
    Write-Error "Visual Studio Installer 未找到：$installerPath"
    exit 1
}

# 逐个卸载
foreach ($instance in $vsInstances) {
    $productId = $instance.productId
    Write-Output "正在卸载: $productId"
    
    # 使用全局安装程序路径并传递 productId
    & "$installerPath" uninstall --productId $productId --passive --norestart
    
    if ($LASTEXITCODE -ne 0) {
        Write-Error "卸载失败: $productId (错误码: $LASTEXITCODE)"
    }
}

Write-Output "所有 Visual Studio 实例已卸载。"
