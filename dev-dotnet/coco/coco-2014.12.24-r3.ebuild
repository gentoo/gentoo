# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOTNET_PKG_COMPAT=8.0
unset NUGET_PACKAGES

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

DOTNET_PKG_BUILD_EXTRA_ARGS=( -p:RollForward=Major )
DOTNET_PKG_PROJECTS=( "${S}/Coco.csproj" )
PATCHES=( "${FILESDIR}/${P}-Coco-csproj.patch" )

src_unpack() {
	dotnet-pkg_src_unpack

	if [[ -n "${EGIT_REPO_URI}" ]] ; then
		git-r3_src_unpack
	fi
}
