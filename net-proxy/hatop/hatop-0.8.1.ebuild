# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} )
PYTHON_REQ_USE="ncurses"

inherit python-r1

DESCRIPTION="Ncurses client and real-time monitoring and displaying of HAProxy status"
HOMEPAGE="https://github.com/jhunt/hatop"
SRC_URI="https://github.com/jhunt/hatop/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

src_install() {
	python_foreach_impl python_doscript bin/hatop

	doman man/hatop.1

	dodoc CHANGES.rst KEYBINDS README.rst
}
