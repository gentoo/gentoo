# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools gnome2-utils ltprune prefix

DESCRIPTION="Japanese FreeWnn input method module for GTK+2"
HOMEPAGE="http://bonobo.gnome.gr.jp/~nakai/immodule/"
SRC_URI="http://bonobo.gnome.gr.jp/~nakai/immodule/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND="app-i18n/freewnn
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-as-needed.patch
	"${FILESDIR}"/${PN}-headers.patch
	"${FILESDIR}"/${PN}-wnnenvrc.patch
)

src_prepare() {
	default
	eprefixify ${PN}.c

	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	default
	prune_libtool_files --modules
}

pkg_postinst() {
	gnome2_query_immodules_gtk2
}

pkg_postrm() {
	gnome2_query_immodules_gtk2
}
