# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_MAJ=$(ver_cut 1-2)

DESCRIPTION="C++ library to emulate the C64 SID chip"
HOMEPAGE="http://sidplay2.sourceforge.net"
SRC_URI="mirror://sourceforge/sidplay2/${P/_p/-p}.tgz"
S="${WORKDIR}"/${PN}-${MY_MAJ}

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc sparc x86"

PATCHES=(
	"${FILESDIR}"/${PN}-0.16_p2-drop-CXXFLAGS-override.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die

	# This is required, otherwise the shared libraries get installed as
	# libresid.0.0.0 instead of libresid.so.0.0.0.
	eautoreconf
}

src_configure() {
	econf \
		--enable-resid-install \
		--enable-shared
}

src_install() {
	default

	dodoc "${S}"/VC_CC_SUPPORT.txt

	find "${ED}" -name '*.la' -delete || die
}
