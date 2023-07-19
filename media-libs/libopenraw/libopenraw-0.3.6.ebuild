# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES=" "
inherit cargo gnome2-utils

DESCRIPTION="RAW image formats decoding library"
HOMEPAGE="https://libopenraw.freedesktop.org/"
SRC_URI="https://${PN}.freedesktop.org/download/${P}.tar.xz"

# MPL-2.0 for mp4parse (https://gitlab.freedesktop.org/libopenraw/libopenraw/-/issues/15)
LICENSE="GPL-3 LGPL-3 MPL-2.0"
SLOT="0/9"
KEYWORDS="amd64 arm arm64 ~mips ~ppc ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="gtk test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/libxml2
	media-libs/libjpeg-turbo:=
	gtk? (
		dev-libs/glib:2
		>=x11-libs/gdk-pixbuf-2.24.0:2
	)
"
DEPEND="
	${RDEPEND}
	dev-libs/boost
"
BDEPEND="
	virtual/pkgconfig
	test? ( net-misc/curl )
"

src_configure() {
	econf \
		--with-boost="${EPREFIX}"/usr \
		$(use_enable gtk gnome)
}

src_compile() {
	# Avoid cargo_src_compile
	default
}

src_test() {
	# Avoid cargo_src_test
	default
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
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
