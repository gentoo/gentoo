# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MAJOR="$(ver_cut 1)"

DOTNET_PKG_COMPAT=8.0
NUGETS="
fsharp.core@8.0.100
system.commandline@2.0.0-beta4.22272.1
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

DOTNET_PKG_PROJECTS=(
	gdmt-check-core/src/GdmtCheckCore/GdmtCheckCore.fsproj
	gdmt-genpwsh/src/GdmtGenpwsh/GdmtGenpwsh.fsproj
	gdmt-gensdk/src/GdmtGensdk/GdmtGensdk.fsproj
	gdmt-restore/src/GdmtRestore/GdmtRestore.fsproj
)
DOTNET_TOOLS=( gdmt-{check-core,genpwsh,gensdk,restore} )

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}

src_install() {
	dotnet-pkg_src_install

	local dotnet_tool
	for dotnet_tool in "${DOTNET_TOOLS[@]}" ; do
		dotnet-pkg-base_dolauncher "/usr/share/${P}/${dotnet_tool}"
	done
}
