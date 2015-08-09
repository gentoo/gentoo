# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT="python2_7"
PYTHON_REQ_USE="ncurses"

inherit python-r1

DESCRIPTION="interactive ncurses client and real-time monitoring,
statistics displaying tool for the HAProxy"
HOMEPAGE="http://feurix.org/projects/hatop/"
SRC_URI="http://hatop.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	net-proxy/haproxy"

src_install() {
	python_foreach_impl python_doscript bin/hatop

	doman man/hatop.1

	dodoc CHANGES KEYBINDS README
}
