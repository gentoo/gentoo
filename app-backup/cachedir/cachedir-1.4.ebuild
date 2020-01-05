# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Tag/untag cache directories"
HOMEPAGE="https://liw.fi/cachedir/"
SRC_URI="http://git.liw.fi/${PN}/snapshot/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

# test deps not supporting python 3
RESTRICT="test"

RDEPEND="dev-python/cliapp[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
#	test? (
#		dev-util/cmdtest[${PYTHON_USEDEP}]
#	)
#	"

python_prepare_all() {
	2to3 -w setup.py || die
	distutils-r1_python_prepare_all
}

src_compile() {
	addwrite /proc/self/comm
	distutils-r1_src_compile
}

src_test() {
	addwrite /proc/self/comm
	distutils-r1_src_test
}

python_test() {
	esetup.py check
}
