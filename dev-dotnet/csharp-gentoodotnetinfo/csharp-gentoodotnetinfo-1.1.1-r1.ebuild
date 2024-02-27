# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=8.0
NUGETS="
microsoft.dotnet.platformabstractions@3.1.6
system.commandline@2.0.0-beta4.22272.1
"

inherit dotnet-pkg

DESCRIPTION=".NET information tool for Gentoo"
HOMEPAGE="https://gitlab.gentoo.org/dotnet/csharp-gentoodotnetinfo/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://gitlab.gentoo.org/dotnet/${PN}.git"
else
	SRC_URI="https://gitlab.gentoo.org/dotnet/${PN}/-/archive/${PV}/${P}.tar.bz2"

	KEYWORDS="amd64 ~arm ~arm64"
fi

SRC_URI+=" ${NUGET_URIS} "

LICENSE="GPL-2+"
SLOT="0"

DOTNET_PKG_PROJECTS=(
	Source/v1/gentoo-dotnet-info-app/GentooDotnetInfo/GentooDotnetInfo.csproj
)

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}

src_install() {
	local launcher_dll="/usr/share/${P}/GentooDotnetInfo.dll"

	dotnet-pkg-base_install
	dotnet-pkg-base_dolauncher_portable "${launcher_dll}" gentoo-dotnet-info

	einstalldocs
}
