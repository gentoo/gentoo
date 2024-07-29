# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MAJOR="$(ver_cut 1)"

DOTNET_PKG_COMPAT=8.0
NUGETS="
fabulous.ast@0.7.0
fantomas.core@6.3.0-alpha-003
fantomas.fcs@6.3.0-alpha-003
fsharp.core@6.0.1
fsharp.core@8.0.100
fsharp.core@8.0.101
fsharp.data.csv.core@6.3.0
fsharp.data.html.core@6.3.0
fsharp.data.http@6.3.0
fsharp.data.json.core@6.3.0
fsharp.data.runtime.utilities@6.3.0
fsharp.data.worldbank.core@6.3.0
fsharp.data.xml.core@6.3.0
fsharp.data@6.3.0
libgit2sharp.nativebinaries@2.0.321
libgit2sharp@0.29.0
microsoft.netcore.platforms@1.1.1
microsoft.netcore.targets@1.1.3
org.xgqt.simplelog@0.0.0
runtime.any.system.runtime@4.3.0
runtime.native.system@4.3.0
runtime.unix.system.private.uri@4.3.0
system.commandline@2.0.0-beta4.22272.1
system.diagnostics.diagnosticsource@7.0.0
system.memory@4.5.5
system.private.uri@4.3.0
system.runtime@4.3.1
"

inherit dotnet-pkg

DESCRIPTION="Gentoo tools for .NET packages maintenance"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Dotnet
	https://gitlab.gentoo.org/dotnet/gentoo-dotnet-maintainer-tools/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://gitlab.gentoo.org/dotnet/${PN}.git"
else
	SRC_URI="https://gitlab.gentoo.org/dotnet/${PN}/-/archive/${PV}/${P}.tar.bz2"

	KEYWORDS="~amd64"
fi

SRC_URI+=" ${NUGET_URIS} "
S="${WORKDIR}/${P}/Source/v${MAJOR}"

LICENSE="GPL-2+"
SLOT="0/${MAJOR}"

DOTNET_PKG_PROJECTS=()
DOTNET_TOOLS=()

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}

src_prepare() {
	dotnet-pkg_src_prepare

	DOTNET_PKG_PROJECTS=( $(find . -name "Gdmt.*proj") )
	DOTNET_TOOLS=( $(cat ./gdmt-tools.txt) )

	einfo "Will build following DOTNET_PKG_PROJECTS: ${DOTNET_PKG_PROJECTS[@]}"
	einfo "Will build following DOTNET_TOOLS: ${DOTNET_TOOLS[@]}"
}

src_install() {
	dotnet-pkg_src_install

	local tool_exe
	for tool_exe in "${DOTNET_TOOLS[@]}" ; do
		dotnet-pkg-base_dolauncher "/usr/share/${P}/${tool_exe}"
	done
}
