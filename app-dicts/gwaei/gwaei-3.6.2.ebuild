# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils

DESCRIPTION="Japanese-English Dictionary for GNOME"
HOMEPAGE="http://gwaei.sourceforge.net/"
SRC_URI="mirror://sourceforge/gwaei/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk hunspell nls mecab test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=net-misc/curl-7.20.0
	>=dev-libs/glib-2.31
	gtk? (
		x11-libs/gtk+:3
		>=app-text/gnome-doc-utils-0.14.0
	)
	hunspell? ( app-text/hunspell )
	nls? ( virtual/libintl )
	mecab? ( app-text/mecab )"
DEPEND="${RDEPEND}
	gtk? (
		x11-themes/gnome-icon-theme-symbolic
		>=app-text/gnome-doc-utils-0.14.0
	)"
BDEPEND="
	app-text/rarian
	dev-util/intltool
	virtual/pkgconfig
	nls? ( >=sys-devel/gettext-0.17 )
	test? (
		app-text/docbook-xml-dtd:4.1.2
		app-text/scrollkeeper-dtd
	)"

src_configure() {
	econf \
		--disable-static \
		$(use_with gtk gnome) \
		$(use_enable nls) \
		$(use_with hunspell) \
		$(use_with mecab)
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}

pkg_preinst() {
	use gtk && gnome2_schemas_savelist
}

pkg_postinst() {
	use gtk && gnome2_schemas_update
}

pkg_postrm() {
	use gtk && gnome2_schemas_update
}
