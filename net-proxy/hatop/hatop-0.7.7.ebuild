# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ncurses"

inherit python-r1

DESCRIPTION="Ncurses client and real-time monitoring and displaying of HAProxy status"
HOMEPAGE="http://feurix.org/projects/hatop/"
SRC_URI="https://hatop.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	net-proxy/haproxy"

src_install() {
	python_foreach_impl python_doscript bin/hatop

	doman man/hatop.1

	dodoc CHANGES KEYBINDS README
}
