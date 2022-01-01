# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit gnome2-utils

DESCRIPTION="RAW image formats decoding library"
HOMEPAGE="https://libopenraw.freedesktop.org/"
SRC_URI="https://${PN}.freedesktop.org/download/${P}.tar.bz2"

LICENSE="GPL-3 LGPL-3"
SLOT="0/7"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ppc64 sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
IUSE="gtk test"
RESTRICT="!test? ( test )"

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
"
BDEPEND="
	virtual/pkgconfig
	test? ( net-misc/curl )
"

src_configure() {
	econf \
		--with-boost="${EPREFIX}"/usr \
		--disable-static \
		$(use_enable gtk gnome)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
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
