# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit gnome2-utils toolchain-funcs

DESCRIPTION="GTK+ 2 Hangul Input Modules"
HOMEPAGE="https://github.com/libhangul/imhangul"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="app-i18n/libhangul
	x11-libs/gtk+:2
	virtual/libintl"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext"

src_prepare() {
	default
	gnome2_environment_reset
	gnome2_disable_deprecation_warning
}

src_configure() {
	econf --with-gtk-im-module-dir="${EPREFIX}"/usr/$(get_libdir)/gtk-2.0/$($(tc-getPKG_CONFIG) gtk+-2.0 --variable=gtk_binary_version)/immodules
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
	dodoc ${PN}.conf

	local s
	insinto /etc/X11/xinit/xinput.d
	for s in 2{,y} 3{2,9,f,s,y} ahn ro; do
		newins "${FILESDIR}"/xinput-${PN}${s} ${PN}${s}.conf
	done
}

pkg_postinst() {
	gnome2_query_immodules_gtk2
	elog
	elog "If you want to use one of the module as a default input method, "
	elog
	elog "export GTK_IM_MODULE=hangul2  # 2 input type"
	elog "export GTK_IM_MODULE=hangul3f # 3 input type"
	elog
}

pkg_postrm() {
	gnome2_query_immodules_gtk2
}
