# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Extra styles pack for flux|black|open(box)"
HOMEPAGE="http://mkeadle.org/"
SRC_URI="
	mirror://gentoo/${P}.tar.bz2
	http://mkeadle.org/distfiles/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 sparc x86"

# xv is there so *box can convert backgrounds/textures to use
RDEPEND="
	media-gfx/xv
	|| (
		x11-wm/fluxbox
		x11-wm/blackbox
		x11-wm/openbox
	)"

src_install() {
	insinto /usr/share/commonbox
	doins -r backgrounds styles

	dodoc README.commonbox-styles-extra
}
