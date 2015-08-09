# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

DESCRIPTION="Libchipcard is a library for easy access to chip cards via chip card readers (terminals)"
HOMEPAGE="http://www.aquamaniac.de/aqbanking/"
SRC_URI="http://www.aquamaniac.de/sites/download/download.php?package=02&release=26&file=01&dummy=${P}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 hppa ppc ~ppc64 ~sparc x86"
IUSE="doc examples"

RDEPEND=">=sys-libs/gwenhywfar-4.2.1
	>=sys-apps/pcsc-lite-1.6.2
	sys-libs/zlib
	virtual/libintl"
DEPEND="${RDEPEND}
	sys-devel/gettext
	doc? ( app-doc/doxygen )"

src_configure() {
	econf \
		--disable-dependency-tracking \
		--disable-static \
		$(use_enable doc full-doc) \
		--with-docpath=/usr/share/doc/${PF}/apidoc
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog NEWS README TODO \
		doc/{CERTIFICATES,CONFIG,IPCCOMMANDS}

	if use examples; then
		docinto tutorials
		dodoc tutorials/*.{c,h,xml} tutorials/README
	fi

	find "${D}" -name '*.la' -exec rm -f {} +
}
