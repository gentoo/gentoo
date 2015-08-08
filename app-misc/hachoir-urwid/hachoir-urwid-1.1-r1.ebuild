# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="ncurses"

inherit distutils-r1

DESCRIPTION="Binary file explorer using Hachoir and urwid libraries"
HOMEPAGE="http://bitbucket.org/haypo/hachoir/wiki/hachoir-urwid http://pypi.python.org/pypi/hachoir-urwid"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/hachoir-core-1.2[${PYTHON_USEDEP}]
	>=dev-python/hachoir-parser-1.0[${PYTHON_USEDEP}]
	>=dev-python/urwid-0.9.4[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

python_configure_all() {
	mydistutilsargs=(
		--setuptools
	)
}
