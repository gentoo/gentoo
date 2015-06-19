# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xdialog/xdialog-2.3.1.ebuild,v 1.10 2014/09/03 08:04:18 jer Exp $

EAPI=5
inherit autotools eutils

DESCRIPTION="drop-in replacement for cdialog using GTK"
HOMEPAGE="http://xdialog.free.fr/"
SRC_URI="http://${PN}.free.fr/Xdialog-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ppc x86"
IUSE="doc examples nls"

RDEPEND="
	dev-libs/glib:2
	>=x11-libs/gtk+-2.2:2
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )
"

S=${WORKDIR}/${P/x/X}

src_prepare() {
	epatch "${FILESDIR}"/${P}-{no-strip,install}.patch
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable nls) \
		--with-gtk2
}

src_install() {
	default
	rm -rf "${D}"/usr/share/doc

	dodoc AUTHORS BUGS ChangeLog README

	use doc && dohtml -r doc/

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins samples/*
	fi
}
