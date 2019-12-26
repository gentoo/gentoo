# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils meson multilib-minimal

DESCRIPTION="WebP Image format GdkPixbuf loader"
HOMEPAGE="https://github.com/aruiz/webp-pixbuf-loader"
SRC_URI="https://github.com/aruiz/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

PATCHES=( "${FILESDIR}/${PN}_gentoo.patch" )

DEPEND="
	>=media-libs/libwebp-0.4.3[${MULTILIB_USEDEP}]
	>=x11-libs/gdk-pixbuf-2.22[${MULTILIB_USEDEP}]
"
RDEPEND="${DEPEND}"

multilib_src_configure() {
	meson_src_configure
}

multilib_src_compile() {
	meson_src_compile
}

multilib_src_test() {
	meson_src_test
}

multilib_src_install() {
	meson_src_install
}

pkg_preinst() {
	gnome2_gdk_pixbuf_savelist
}

pkg_postinst() {
	gnome2_gdk_pixbuf_update
}

pkg_postrm() {
	gnome2_gdk_pixbuf_update
}
