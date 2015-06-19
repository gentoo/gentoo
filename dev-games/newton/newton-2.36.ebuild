# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-games/newton/newton-2.36.ebuild,v 1.3 2015/04/21 17:45:08 pacho Exp $

EAPI=5
inherit eutils toolchain-funcs cmake-utils unpacker

MY_P="${PN}-dynamics-${PV}"
DESCRIPTION="an integrated solution for real time simulation of physics environments"
HOMEPAGE="http://code.google.com/p/newton-dynamics/"
SRC_URI="http://newton-dynamics.googlecode.com/files/${MY_P}.rar"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="$(unpacker_src_uri_depends)"

S=${WORKDIR}/${MY_P}

src_prepare() {
	cp "${FILESDIR}"/CMakeLists.txt "${S}" || die
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_PREFIX=/usr/
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_install
}
