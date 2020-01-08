# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python{2_7,3_{6,7}} )

inherit distutils-r1

DESCRIPTION="ANSI escape character sequences for colored terminal text & cursor positioning"
HOMEPAGE="
	https://pypi.org/project/colorama/
	https://github.com/tartley/colorama
"
# https://github.com/tartley/colorama/pull/183
SRC_URI="https://github.com/tartley/${PN}/archive/${PV}.tar.gz -> ${P}.github.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="examples test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

python_install_all() {
	distutils-r1_python_install_all

	if use examples; then
		docinto examples
		dodoc -r demos/.
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

python_test() {
	# Some tests require stdout to be a TTY
	# https://github.com/tartley/colorama/issues/169
	script -eqc "pytest -vv -s" /dev/null \
		|| die "tests failed with ${EPYTHON}"
}
