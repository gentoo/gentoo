# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cmake-utils

DESCRIPTION="Numerical analysis and data processing library"
HOMEPAGE="http://www.alglib.net/"
SRC_URI="http://www.alglib.net/translator/re/${P}.cpp.tgz"

SLOT="0"
LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

S="${WORKDIR}"/cpp/

src_prepare() {
	cp "${FILESDIR}"/CMakeLists.txt-${PV} CMakeLists.txt || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=( $(cmake-utils_use_build test) )
	cmake-utils_src_configure
}
