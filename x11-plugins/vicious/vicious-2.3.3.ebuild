# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Modular widget library for x11-wm/awesome"
HOMEPAGE="https://github.com/Mic92/vicious"
SRC_URI="https://github.com/Mic92/vicious/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="contrib"

DEPEND=""
RDEPEND="x11-wm/awesome"

src_install() {
	insinto /usr/share/awesome/lib/vicious
	doins -r widgets helpers.lua init.lua
	dodoc Changes.md README.md TODO

	if use contrib; then
		insinto /usr/share/awesome/lib/vicious/contrib
		doins contrib/*.lua
		newdoc contrib/README.md README.contrib
	fi
}
