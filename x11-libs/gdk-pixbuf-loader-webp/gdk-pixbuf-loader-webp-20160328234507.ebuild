# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

EGIT_REPO_URI="https://github.com/aruiz/webp-pixbuf-loader"
EGIT_COMMIT=9b92950d49d7939f90ba7413deb7ec6b392b2054

inherit git-r3 cmake-multilib gnome2-utils

DESCRIPTION="WebP Image format GdkPixbuf loader"
HOMEPAGE="https://github.com/aruiz/webp-pixbuf-loader"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=media-libs/libwebp-0.4.3
	>=x11-libs/gdk-pixbuf-2.22"
RDEPEND="${DEPEND}"

multilib_src_configure() {
	local mycmakeargs=( -DINSTALL_LIB_DIR:PATH=$(get_libdir) )
	cmake-utils_src_configure
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
