# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

DESCRIPTION="ANSI escape character sequences for colored terminal text & cursor positioning"
HOMEPAGE="
	https://pypi.org/project/colorama/
	https://github.com/tartley/colorama/
"
SRC_URI="
	https://github.com/tartley/colorama/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		docinto examples
		dodoc -r demos/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

python_test() {
	local -x PYTEST_DISABLE_PLUGIN_AUTOLOAD=1
	# Some tests require stdout to be a TTY
	# https://github.com/tartley/colorama/issues/169
	script -eqc "${EPYTHON} -m pytest -vv -s" /dev/null \
		|| die "tests failed with ${EPYTHON}"
}
