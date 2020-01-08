# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils gnome2-utils

DESCRIPTION="A decoding library for RAW image formats"
HOMEPAGE="https://libopenraw.freedesktop.org/wiki/"
SRC_URI="https://${PN}.freedesktop.org/download/${P}.tar.bz2"

LICENSE="GPL-3 LGPL-3"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="gtk static-libs test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/jpeg:0
	dev-libs/libxml2
	gtk? (
		>=dev-libs/glib-2
		>=x11-libs/gdk-pixbuf-2.24.0:2
		)"
DEPEND="${RDEPEND}
	>=dev-libs/boost-1.35
	virtual/pkgconfig
	test? ( net-misc/curl )"

DOCS=( AUTHORS ChangeLog NEWS README TODO )

src_prepare() {
	has_version '>=media-libs/jpeg-9a:0' && epatch "${FILESDIR}"/${P}-jpeg-9a.patch
}

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
	gnome2_gdk_pixbuf_savelist
}

pkg_postinst() {
	gnome2_gdk_pixbuf_update
}

pkg_postinst() {
	gnome2_gdk_pixbuf_update
}
