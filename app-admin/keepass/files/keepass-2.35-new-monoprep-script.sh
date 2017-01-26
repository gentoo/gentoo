#!/bin/sh

buildDir="$(pwd)"
keePassRootDir="${buildDir}/.."

copyKeePassIcons()
{
    cd "${buildDir}"
    cp -f ../Ext/Icons_04_CB/Finals2/plockb.ico ../KeePass/KeePass.ico
    cp -f ../Ext/Icons_04_CB/Finals2/plockb.ico ../KeePass/Resources/Images/KeePass.ico
}

sanitizeKeePassProjectFiles()
{
    cd "${keePassRootDir}/KeePass"
    
    local keePassProjectFile="KeePass.csproj"
    local keePassProjectSolution="KeePass.sln"
   
    sed -i 's!<SignAssembly>true</SignAssembly>!<SignAssembly>false</SignAssembly>!g' "${keePassProjectFile}"
    sed -i 's! ToolsVersion="3.5"!!g' "${keePassProjectFile}"
    sed -i '/sgen\.exe/d' "${keePassProjectFile}"
    
    # Update solution .NET format to 11 (This targets Mono 4 rather than 3.5)
    cd "${keePassRootDir}"
    sed -i 's!Format Version 10.00!Format Version 11.00!g' "${keePassProjectSolution}"
    
    cd "${buildDir}"
}

sanitizeKeePassLibProjectFile()
{
    cd "${keePassRootDir}/KeePassLib"
    
    local keePassProjectLibFile="KeePassLib.csproj"
    sed -i 's!<SignAssembly>true</SignAssembly>!<SignAssembly>false</SignAssembly>!g' "${keePassProjectLibFile}"
    sed -i 's! ToolsVersion="3.5"!!g' "${keePassProjectLibFile}"
    
    cd "${buildDir}"
}


sanitizeTrlUtilProjectFile()
{
    cd "${keePassRootDir}/Translation/TrlUtil"
    
    local trlUtilProjectFile="TrlUtil.csproj"
    sed -i 's! ToolsVersion="3.5"!!g' "${trlUtilProjectFile}"
    
    cd "${buildDir}"
}

# Start
copyKeePassIcons

# Remove ToolsVersion 3.5 References so that newer Mono compilers can be used
sanitizeKeePassProjectFiles
sanitizeKeePassLibProjectFile
sanitizeTrlUtilProjectFile
