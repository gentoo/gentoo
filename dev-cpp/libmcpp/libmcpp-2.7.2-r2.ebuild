# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

MY_P=${P/lib/}

DESCRIPTION="A portable C++ preprocessor"
HOMEPAGE="http://mcpp.sourceforge.net"
SRC_URI="mirror://sourceforge/mcpp/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~ia64 x86 ~x86-linux ~x64-macos"
IUSE="static-libs"

DEPEND=""
RDEPEND=""

S=${WORKDIR}/${MY_P}

PATCHES=( "${FILESDIR}"/${PN}-2.7.2-fix-build-system.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--enable-mcpplib \
		$(use_enable static-libs static)
}

src_install() {
	default

	if ! use static-libs; then
		find "${D}" -name '*.la' -delete || die
	fi
}
