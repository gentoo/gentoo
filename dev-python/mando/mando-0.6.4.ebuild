# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="Create Python CLI apps with little to no effort at all!"
HOMEPAGE="https://mando.readthedocs.io/ https://github.com/rubik/mando/"
SRC_URI="https://github.com/rubik/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples"

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_test() {
	"${EPYTHON}" mando/tests/run.py || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}
