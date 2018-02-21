# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit gnome2-utils ltprune

DESCRIPTION="A decoding library for RAW image formats"
HOMEPAGE="https://libopenraw.freedesktop.org/wiki/"
SRC_URI="https://${PN}.freedesktop.org/download/${P}.tar.bz2"

LICENSE="GPL-3 LGPL-3"
SLOT="0/7"
KEYWORDS="~alpha amd64 ~arm ~hppa ia64 ~mips ~ppc ~ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="gtk static-libs test"

RDEPEND="
	dev-libs/libxml2
	virtual/jpeg:0
	gtk? (
		dev-libs/glib:2
		>=x11-libs/gdk-pixbuf-2.24.0:2
	)
"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.35
	virtual/pkgconfig
	test? ( net-misc/curl )
"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_configure() {
	econf \
		--with-boost="${EPREFIX}"/usr \
		$(use_enable static-libs static) \
		$(use_enable gtk gnome)
}

src_install() {
	default
	prune_libtool_files --all
}

pkg_preinst() {
	use gtk && gnome2_gdk_pixbuf_savelist
}

pkg_postinst() {
	use gtk && gnome2_gdk_pixbuf_update
}

pkg_postrm() {
	use gtk && gnome2_gdk_pixbuf_update
}
