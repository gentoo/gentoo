# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2-utils meson-multilib

DESCRIPTION="WebP GDK Pixbuf Loader library"
HOMEPAGE="https://github.com/aruiz/webp-pixbuf-loader"
SRC_URI="https://github.com/aruiz/webp-pixbuf-loader/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/webp-pixbuf-loader-${PV}"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="
	>x11-libs/gdk-pixbuf-2.22.0:2[${MULTILIB_USEDEP}]
	>media-libs/libwebp-0.4.3:=[${MULTILIB_USEDEP}]
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local emesonargs=(
		-Dupdate_cache=false
	)
	multilib_foreach_abi meson_src_configure
}

pkg_preinst() {
	gnome2_gdk_pixbuf_savelist
}

pkg_postinst() {
	# causes segfault if set, see bug 375615
	unset __GL_NO_DSO_FINALIZER
	multilib_foreach_abi gnome2_gdk_pixbuf_update
}

pkg_postrm() {
	# causes segfault if set, see bug 375615
	unset __GL_NO_DSO_FINALIZER
	multilib_foreach_abi gnome2_gdk_pixbuf_update
}
