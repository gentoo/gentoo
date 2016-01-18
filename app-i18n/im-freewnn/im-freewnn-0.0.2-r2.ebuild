# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils gnome2-utils multilib

DESCRIPTION="Japanese FreeWnn input method module for GTK+2"
HOMEPAGE="http://bonobo.gnome.gr.jp/~nakai/immodule/"
SRC_URI="http://bonobo.gnome.gr.jp/~nakai/immodule/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	x11-libs/pango
	>=x11-libs/gtk+-2.4:2
	>=app-i18n/freewnn-1.1.1_alpha21-r1
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

pkg_setup() {
	# An arch specific config directory is used on multilib systems
	has_multilib_profile && GTK2_CONFDIR="/etc/gtk-2.0/${CHOST}"
	GTK2_CONFDIR=${GTK2_CONFDIR:=/etc/gtk-2.0/}
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-wnnrc-gentoo.diff"
	# bug #298744
	epatch "${FILESDIR}/${P}-as-needed.patch"
	epatch "${FILESDIR}/${P}-implicit-declaration.patch"

	mv configure.in configure.ac || die
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
