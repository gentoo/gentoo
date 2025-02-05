# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT="9.0"
NUGET_PACKAGES=""

inherit dotnet-pkg

DESCRIPTION="The compiler generator Coco/R for C#"
HOMEPAGE="https://github.com/boogie-org/coco/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/boogie-org/${PN}.git"
else
	SRC_URI="https://github.com/boogie-org/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64"
fi

LICENSE="GPL-2+"
SLOT="0"

DOTNET_PKG_PROJECTS=( Coco.csproj )
PATCHES=( "${FILESDIR}/coco-2014.12.24-Coco-csproj-net9.patch" )

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}
