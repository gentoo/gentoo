# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Extra styles pack for flux|black|open(box)"
HOMEPAGE="http://mkeadle.org/"
SRC_URI="mirror://gentoo/${P}.tar.bz2
	http://mkeadle.org/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 sparc x86"
IUSE=""

# xv is there so *box can convert backgrounds/textures to use
RDEPEND="media-gfx/xv
	|| ( x11-wm/fluxbox x11-wm/blackbox x11-wm/openbox )"

src_install () {
	insinto /usr/share/commonbox/styles
	doins -r styles/.

	insinto /usr/share/commonbox/backgrounds
	doins -r backgrounds/.

	dodoc README.commonbox-styles-extra
}
