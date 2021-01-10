# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3 toolchain-funcs

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
PATCHES=(
	"${FILESDIR}"/${PN}-99999999-Debian.patch
	"${FILESDIR}"/${PN}-99999999-desktop.patch
	"${FILESDIR}"/${PN}-99999999-fno-common.patch
	"${FILESDIR}"/${PN}-99999999-strncat.patch
)
DOCS=(
	README
	scripts/keybind_help.sh
	scripts/status.sh
)

src_configure() {
	tc-export CC
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
