# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmpd/libmpd-11.8.17.ebuild,v 1.6 2012/05/05 08:02:30 jdhore Exp $

EAPI=4

DESCRIPTION="A library handling connections to a MPD server"
HOMEPAGE="http://gmpc.wikia.com/wiki/Libmpd"
SRC_URI="http://download.sarine.nl/Programs/gmpc/11.8/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86 ~x86-interix ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

RDEPEND=">=dev-libs/glib-2.16:2"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

src_configure() {
	econf \
		$(use_enable static-libs static) \
		--docdir="${EPREFIX}"/usr/share/doc/${PF}
}

src_compile() {
	emake
	use doc && emake -C doc doc
}

src_install() {
	default
	use doc && dohtml -r doc/html/*
	find "${ED}" -name "*.la" -exec rm -rf {} + || die
	rm "${ED}"/usr/share/doc/${PF}/{README,ChangeLog} || die
}
