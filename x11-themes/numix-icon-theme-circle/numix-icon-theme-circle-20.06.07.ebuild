# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

DESCRIPTION="Icon theme from the Numix project"
HOMEPAGE="https://github.com/numixproject"
SRC_URI="https://github.com/numixproject/numix-icon-theme-circle/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="x11-themes/numix-icon-theme"

src_install() {
	insinto /usr/share/icons
	doins -r Numix-Circle{,-Light}

}
