# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/xcdroast/xcdroast-0.98_alpha16.ebuild,v 1.8 2012/05/03 07:51:50 jdhore Exp $

EAPI=2
inherit gnome2-utils eutils

DESCRIPTION="Lightweight cdrtools front-end for CD and DVD writing"
HOMEPAGE="http://www.xcdroast.org/"
SRC_URI="mirror://sourceforge/xcdroast/${P/_/}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE="nls"

RDEPEND=">=x11-libs/gtk+-2:2
	app-cdr/cdrtools"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${P/_/}

src_prepare() {
	epatch "${FILESDIR}"/io_compile.patch
}

src_configure() {
	econf \
		$(use_enable nls) \
		--enable-gtk2 \
		--disable-dependency-tracking \
		--mandir=/usr/share/man \
		--sysconfdir=/etc
}

src_compile() {
	emake PREFIX=/usr || die
}

src_install() {
	emake PREFIX=/usr DESTDIR="${D}" install || die

	dodoc AUTHORS ChangeLog README doc/{README*,DOCUMENTATION,FAQ,TRANS*} \
		doc/manual/README.txt

	insinto /usr/share/doc/${PF}/manual
	doins doc/manual/xcdroast-manual.pdf

	insinto /usr/share/icons/hicolor/48x48/apps
	newins xpms/xcdricon.xpm xcdroast.xpm

	make_desktop_entry xcdroast "X-CD-Roast" xcdroast "AudioVideo;DiscBurning"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
