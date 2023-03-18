# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Simplifies the usage of decorators for the average programmer"
HOMEPAGE="
	https://github.com/micheles/decorator/
	https://pypi.org/project/decorator/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~x64-macos"

DOCS=( CHANGES.md )

python_test() {
	"${EPYTHON}" src/tests/test.py -v || die "Tests failed with ${EPYTHON}"
}
