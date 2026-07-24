# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

APP_PN="platyPS"

DOTNET_PKG_COMPAT="10.0"
NUGETS="
markdig.signed@0.33.0
microsoft.csharp@4.7.0
microsoft.netframework.referenceassemblies.net472@1.0.3
microsoft.netframework.referenceassemblies@1.0.3
powershellstandard.library@5.1.1
system.buffers@4.5.1
system.memory@4.5.4
system.numerics.vectors@4.5.0
system.runtime.compilerservices.unsafe@4.5.3
yamldotnet@15.1.6
"

inherit dotnet-pkg check-reqs edo readme.gentoo-r1

DESCRIPTION="Generate PowerShell external help files from Markdown"
HOMEPAGE="https://github.com/PowerShell/platyPS/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/PowerShell/${APP_PN}"
else
	SRC_URI="https://github.com/PowerShell/${APP_PN}/archive/refs/tags/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${APP_PN}-${PV}"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="MIT"
SLOT="${PV}"

RDEPEND="
	virtual/pwsh:*
"
BDEPEND="
	${RDEPEND}
"

CHECKREQS_DISK_BUILD="1G"
DOTNET_PKG_PROJECTS=( src/Microsoft.PowerShell.PlatyPS.csproj )

DOCS=( CHANGELOG.md README.md )

pkg_setup() {
	check-reqs_pkg_setup
	dotnet-pkg_pkg_setup
}

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}

src_prepare() {
	dotnet-pkg_src_prepare

	cat << EOF > NuGet.config || die
<?xml version="1.0" encoding="utf-8"?>
<configuration>
<packageSources>
<clear />
<add key="nuget" value="${NUGET_PACKAGES}" />
</packageSources>
</configuration>
EOF
}

src_compile() {
	dotnet-pkg_src_compile

	local -a ps1opts=(
		-Configuration "${DOTNET_PKG_CONFIGURATION}"
	)
	edo pwsh -NoProfile -NonInteractive ./build.ps1 "${ps1opts[@]}"
}

src_install() {
	insinto "/usr/share/GentooPowerShell/Modules/Microsoft.PowerShell.PlatyPS/${PV}"
	doins -r ./out/Microsoft.PowerShell.PlatyPS/.
	einstalldocs

	local DOC_CONTENTS="To import platPS use:
		\n\tImport-Module -Force -Verbose Microsoft.PowerShell.PlatyPS"
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
