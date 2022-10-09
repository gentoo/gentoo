# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Python subprocess interface"
HOMEPAGE="
	https://github.com/amoffat/sh/
	https://pypi.org/project/sh/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

PATCHES=(
	"${FILESDIR}/sh-1.12.14-skip-unreliable-test.patch"
	"${FILESDIR}/sh-1.14.0-skip-unreliable-test.patch"
)

python_test() {
	"${EPYTHON}" test.py || die "Tests fail with ${EPYTHON}"
}
