# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( pypy3 python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A thin, practical wrapper around terminal coloring, styling, and positioning"
HOMEPAGE="https://github.com/erikrose/blessings https://pypi.org/project/blessings/"
# https://github.com/erikrose/blessings/pull/136
SRC_URI="https://github.com/erikrose/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ~riscv x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-python/six[${PYTHON_USEDEP}]"

distutils_enable_sphinx docs
distutils_enable_tests nose

python_test() {
	# The tests need an interactive terminal
	# https://github.com/erikrose/blessings/issues/117
	script -eqc "nosetests -v -w \"${BUILD_DIR}\"" /dev/null \
		|| die "tests failed with ${EPYTHON}"
}
