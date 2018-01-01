# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Gtk+-3.0 Hangul Input Modules"
HOMEPAGE="https://code.google.com/p/imhangul/"
SRC_URI="https://imhangul.googlecode.com/files/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="3"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND=">=app-i18n/libhangul-0.0.12
	x11-libs/gtk+:3
	virtual/libintl"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext"

src_prepare() {
	default

	# Drop DEPRECATED flags, bug #387825
	sed -i -e 's:-D[A-Z_]*DISABLE_DEPRECATED:$(NULL):g' Makefile.am Makefile.in || die
}

src_configure() {
	econf --with-gtk-im-module-dir="${EPREFIX}/usr/$(get_libdir)/gtk-3.0/$(pkg-config gtk+-3.0 --variable=gtk_binary_version)/immodules"
}

src_install() {
	default
	dodoc imhangul.conf

	insinto /etc/X11/xinit/xinput.d
	newins "${FILESDIR}/xinput-imhangul2" imhangul2.conf
	newins "${FILESDIR}/xinput-imhangul2y" imhangul2y.conf
	newins "${FILESDIR}/xinput-imhangul32" imhangul32.conf
	newins "${FILESDIR}/xinput-imhangul39" imhangul39.conf
	newins "${FILESDIR}/xinput-imhangul3f" imhangul3f.conf
	newins "${FILESDIR}/xinput-imhangul3s" imhangul3s.conf
	newins "${FILESDIR}/xinput-imhangul3y" imhangul3y.conf
	newins "${FILESDIR}/xinput-imhangulahn" imhangulahn.conf
	newins "${FILESDIR}/xinput-imhangulro" imhangulro.conf

	find "${D}" -name '*.la' -delete || die
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
