# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/wmfs/wmfs-201003.ebuild,v 1.3 2015/07/28 05:13:54 jer Exp $

EAPI=5
inherit cmake-utils eutils

DESCRIPTION="Window Manager From Scratch, A tiling window manager highly configurable"
HOMEPAGE="https://github.com/xorg62/wmfs"
SRC_URI="${HOMEPAGE}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	media-libs/freetype
	media-libs/imlib2[X]
	x11-libs/libX11
	x11-libs/libXft
	x11-libs/libXinerama
	x11-libs/libXrandr
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	x11-proto/randrproto
	x11-proto/xineramaproto
	x11-proto/xproto
"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-201003-desktop.patch \
		"${FILESDIR}"/${PN}-201003-pthread.patch
}

src_install() {
	cmake-utils_src_install
	rm -r "${D}"/usr/share/${PN}
	dodoc README TODO rc/status.sh
}
