# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
inherit gnome2-utils multilib

DESCRIPTION="Gtk+-3.0 Hangul Input Modules"
HOMEPAGE="https://code.google.com/p/imhangul/"
SRC_URI="https://imhangul.googlecode.com/files/${P}.tar.bz2"

SLOT="3"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=app-i18n/libhangul-0.0.12
	x11-libs/gtk+:3
	virtual/libintl"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext"

src_prepare() {
	# Drop DEPRECATED flags, bug #387825
	sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' Makefile.am Makefile.in || die
}

src_configure() {
	econf --with-gtk-im-module-dir="${EPREFIX}/usr/$(get_libdir)/gtk-3.0/$(pkg-config gtk+-3.0 --variable=gtk_binary_version)/immodules" || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	find "${ED}" -name "*.la" -type f -delete || die

	insinto /etc/X11/xinit/xinput.d
	newins "${FILESDIR}/xinput-imhangul2" imhangul2.conf || die
	newins "${FILESDIR}/xinput-imhangul2y" imhangul2y.conf || die
	newins "${FILESDIR}/xinput-imhangul32" imhangul32.conf || die
	newins "${FILESDIR}/xinput-imhangul39" imhangul39.conf || die
	newins "${FILESDIR}/xinput-imhangul3f" imhangul3f.conf || die
	newins "${FILESDIR}/xinput-imhangul3s" imhangul3s.conf || die
	newins "${FILESDIR}/xinput-imhangul3y" imhangul3y.conf || die
	newins "${FILESDIR}/xinput-imhangulahn" imhangulahn.conf || die
	newins "${FILESDIR}/xinput-imhangulro" imhangulro.conf || die

	dodoc AUTHORS ChangeLog NEWS README TODO imhangul.conf || die
}

pkg_postinst() {
	gnome2_query_immodules_gtk3

	elog ""
	elog "If you want to use one of the module as a default input method, "
	elog ""
	elog "export GTK_IM_MODULE=hangul2  # 2 input type"
	elog "export GTK_IM_MODULE=hangul3f # 3 input type"
	elog ""
}

pkg_postrm() {
	gnome2_query_immodules_gtk3
}
