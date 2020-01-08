# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils

DESCRIPTION="Tools and a library for creating flame fractal images"
HOMEPAGE="http://flam3.com/"
SRC_URI="https://github.com/scottdraves/flam3/archive/v$PV.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="static-libs"

RDEPEND="dev-libs/libxml2
	media-libs/libpng:=
	virtual/jpeg:=
	!<=x11-misc/electricsheep-2.6.8-r2"
DEPEND="${RDEPEND}"

DOCS=( README.txt )

src_prepare() {
	eautoreconf
	eapply_user
}

src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static)
}

src_install() {
	default

	rm -f "${D}"usr/lib*/libflam3.la

	docinto examples
	dodoc *.flam3
}
