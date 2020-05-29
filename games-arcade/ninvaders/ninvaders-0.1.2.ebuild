# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake

DESCRIPTION="a Space Invaders clone based on ncurses for ASCII output"
HOMEPAGE="https://github.com/sf-refugees/ninvaders
	http://ninvaders.sourceforge.net/"
SRC_URI="https://github.com/sf-refugees/ninvaders/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-libs/ncurses:0="
