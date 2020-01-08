# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="An X11 implementation maintained by the X.Org Foundation (meta package)"
HOMEPAGE="https://www.x.org/wiki/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sh sparc x86"
IUSE="+fonts"

# Server
RDEPEND="${RDEPEND}
	x11-base/xorg-server[-minimal]"

# Applications
RDEPEND="${RDEPEND}
	x11-apps/appres
	x11-apps/bitmap
	x11-apps/iceauth
	x11-apps/luit
	>=x11-apps/mkfontscale-1.2.0
	x11-apps/sessreg
	x11-apps/setxkbmap
	x11-apps/smproxy
	x11-apps/x11perf
	x11-apps/xauth
	|| ( x11-apps/xbacklight sys-power/acpilight )
	x11-apps/xcmsdb
	x11-apps/xcursorgen
	x11-apps/xdpyinfo
	x11-apps/xdriinfo
	x11-apps/xev
	x11-apps/xf86dga
	x11-apps/xgamma
	x11-apps/xhost
	x11-apps/xinput
	x11-apps/xkbcomp
	x11-apps/xkbevd
	x11-apps/xkbutils
	x11-apps/xkill
	x11-apps/xlsatoms
	x11-apps/xlsclients
	x11-apps/xmodmap
	x11-apps/xpr
	x11-apps/xprop
	x11-apps/xrandr
	x11-apps/xrdb
	x11-apps/xrefresh
	x11-apps/xset
	x11-apps/xsetroot
	x11-apps/xvinfo
	x11-apps/xwd
	x11-apps/xwininfo
	x11-apps/xwud
	"

# Data
RDEPEND="${RDEPEND}
	x11-misc/xbitmaps
	x11-themes/xcursor-themes
	"

# Utilities
RDEPEND="${RDEPEND}
	x11-misc/makedepend
	x11-misc/util-macros
	"

# Fonts
RDEPEND="${RDEPEND}
	fonts? (
		media-fonts/font-adobe-100dpi
		media-fonts/font-adobe-75dpi
		media-fonts/font-adobe-utopia-100dpi
		media-fonts/font-adobe-utopia-75dpi
		media-fonts/font-adobe-utopia-type1
		media-fonts/font-alias
		media-fonts/font-arabic-misc
		media-fonts/font-bh-100dpi
		media-fonts/font-bh-75dpi
		media-fonts/font-bh-lucidatypewriter-100dpi
		media-fonts/font-bh-lucidatypewriter-75dpi
		media-fonts/font-bh-ttf
		media-fonts/font-bh-type1
		media-fonts/font-bitstream-100dpi
		media-fonts/font-bitstream-75dpi
		media-fonts/font-bitstream-speedo
		media-fonts/font-bitstream-type1
		media-fonts/font-cronyx-cyrillic
		media-fonts/font-cursor-misc
		media-fonts/font-daewoo-misc
		media-fonts/font-dec-misc
		media-fonts/font-ibm-type1
		media-fonts/font-isas-misc
		media-fonts/font-jis-misc
		media-fonts/font-micro-misc
		media-fonts/font-misc-cyrillic
		media-fonts/font-misc-ethiopic
		media-fonts/font-misc-meltho
		media-fonts/font-misc-misc
		media-fonts/font-mutt-misc
		media-fonts/font-schumacher-misc
		media-fonts/font-screen-cyrillic
		media-fonts/font-sony-misc
		media-fonts/font-sun-misc
		media-fonts/font-util
		media-fonts/font-winitzki-cyrillic
		media-fonts/font-xfree86-type1

		media-fonts/font-alias
		media-fonts/font-util
		media-fonts/encodings
	)
	"

DEPEND="${RDEPEND}"

pkg_postinst() {
	elog
	elog "Please note that the xcursors are in ${EROOT%/}/usr/share/cursors/${PN}."
	elog "Any custom cursor sets should be placed in that directory."
	elog
	elog "If you wish to set system-wide default cursors, please create"
	elog "${EROOT%/}/usr/local/share/cursors/${PN}/default/index.theme"
	elog "with content: \"Inherits=theme_name\" so that future"
	elog "emerges will not overwrite those settings."
	elog
	elog "Listening on TCP is disabled by default with startx."
	elog "To enable it, edit ${EROOT%/}/usr/bin/startx."
	elog

	elog "Visit https://wiki.gentoo.org/wiki/Category:X.Org"
	elog "for more information on configuring X."
	elog
}
