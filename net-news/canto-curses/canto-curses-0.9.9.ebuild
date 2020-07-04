# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )
PYTHON_REQ_USE="ncurses(+),threads(+)"
inherit distutils-r1 multilib

DESCRIPTION="The ncurses client for canto-daemon"
HOMEPAGE="https://codezen.org/canto-ng/"
SRC_URI="https://github.com/themoken/canto-curses/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND=">=net-news/canto-daemon-0.9.1[${PYTHON_USEDEP}]"

python_prepare_all() {
	# Respect libdir during plugins installation
	sed -i -e "s:lib/canto:$(get_libdir)/canto:" setup.py || die

	distutils-r1_python_prepare_all
}
