# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="Pretending python is a shell"
HOMEPAGE="https://pypi.org/project/whelk/"
SRC_URI="https://github.com/seveas/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

python_test() {
	${EPYTHON} -m unittest discover || die
}
