# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit eutils git-r3

DESCRIPTION="Window Manager From Scratch, A tiling window manager highly configurable"
HOMEPAGE="https://github.com/xorg62/wmfs"
EGIT_REPO_URI="https://github.com/xorg62/wmfs"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="+imlib2 +xinerama"

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
	x11-base/xorg-proto
"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-99999999-desktop.patch

	sed -i -e '/^which dpkg/s|.*|false|g' configure || die
}

src_configure() {
	# not autotools based
	local ECHO
	for ECHO in echo ''; do
		${ECHO} sh configure \
			$(usex xinerama '' --without-xinerama) \
			$(usex imlib2 '' --without-imlib2) \
			--prefix /usr \
			--man-prefix /usr/share/man \
			--xdg-config-dir /etc/xdg \
			|| die
	done
}

src_install() {
	default
	rm -r "${D}"/usr/share/${PN}
	dodoc README
}
