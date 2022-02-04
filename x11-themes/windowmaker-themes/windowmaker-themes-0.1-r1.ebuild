# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# TODO: Break themes up by author and into sub-dirs named after
# the author

DESCRIPTION="Collection of Window Maker themes"
HOMEPAGE="http://www.windowmaker.org/"
# Original site: http://gentoo.asleep.net/windowmaker-themes
SRC_URI="https://dev.gentoo.org/~voyageur/distfiles/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc sparc x86"
IUSE="offensive"

DEPEND=""
RDEPEND="x11-wm/windowmaker"
BDEPEND=""

src_prepare() {
	MY_OFFENSIVE=(
		3White
		Anguish
		Crave
		"Darwins iMac"
		"Digital Girls"
		"Imacgirl Grape"
		"Red Slip"
		WMSecksy
	)
	if ! use offensive ; then
		for j in "${MY_OFFENSIVE[@]}" ; do
			rm -rf "${j}".themed
		done
	fi

	default
}

src_install() {
	insinto /usr/share/WindowMaker/Themes
	doins -r .
}

pkg_postinst() {
	einfo "The Window Maker themes downloaded are by the following artists:"
	einfo "A.Sleep - http://www.asleep.net/"
	einfo "Largo   - http://largo.windowmaker.org/"
	einfo "Hadess  - http://www.hadess.net/"
	einfo "jenspen - http://themes.freshmeat.net/~jenspen/"
}
