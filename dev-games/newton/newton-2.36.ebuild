# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs cmake-utils unpacker

MY_P="${PN}-dynamics-${PV}"
DESCRIPTION="an integrated solution for real time simulation of physics environments"
HOMEPAGE="https://code.google.com/p/newton-dynamics/"
SRC_URI="https://newton-dynamics.googlecode.com/files/${MY_P}.rar"

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
