# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/zeux/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/zeux/${PN}/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"
fi

DESCRIPTION="Light-weight, simple, and fast XML parser for C++ with XPath support"
HOMEPAGE="https://pugixml.org/ https://github.com/zeux/pugixml/"

LICENSE="MIT"
SLOT="0"

PATCHES=(
	"${FILESDIR}/${P}-always-install-the-pkg-config-file.patch"
	"${FILESDIR}/${P}-Use-CMAKE_INSTALL_LIBDIR-for-pugixml.pc.patch"
	"${FILESDIR}/${P}-pkg-config-Use-CMake-GnuInstallDirs-FULL-vars.patch"
)
