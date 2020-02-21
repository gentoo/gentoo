# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
CMAKE_MAKEFILE_GENERATOR=emake

inherit cmake-utils

DESCRIPTION="Light-weight, simple, and fast XML parser for C++ with XPath support"
HOMEPAGE="https://pugixml.org/ https://github.com/zeux/pugixml/"
SRC_URI="https://github.com/zeux/${PN}/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux"

src_configure() {
	local mycmakeargs=( -DBUILD_SHARED_LIBS=ON )
	cmake-utils_src_configure
}
