# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6,3_7} pypy )

inherit distutils-r1

DESCRIPTION="Python IP address manipulation library"
HOMEPAGE="https://github.com/google/ipaddr-py https://pypi.org/project/ipaddr/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare() {
	if python_is_python3; then
		2to3 -n -w --no-diffs *.py || die
	fi
}

python_test() {
	distutils_install_for_testing
	"${EPYTHON}" ipaddr_test.py || die "Tests fail with ${EPYTHON}"
}
