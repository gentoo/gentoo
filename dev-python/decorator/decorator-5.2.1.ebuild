# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3_11 python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Simplifies the usage of decorators for the average programmer"
HOMEPAGE="
	https://github.com/micheles/decorator/
	https://pypi.org/project/decorator/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos"

python_test() {
	"${EPYTHON}" tests/test.py -v || die "Tests failed with ${EPYTHON}"
}
