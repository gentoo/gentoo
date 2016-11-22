# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} pypy )

inherit distutils-r1

DESCRIPTION="Fork of pathlib aiming to support the full stdlib Python API"
HOMEPAGE="https://github.com/mcmtroffaes/pathlib2"
SRC_URI="mirror://pypi/p/pathlib2/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"

python_test() {
	${EPYTHON} test_pathlib2.py || die
}
