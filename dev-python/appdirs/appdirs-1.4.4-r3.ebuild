# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..14} python3_{13,14}t pypy3_11 )

inherit distutils-r1

DESCRIPTION="Module for determining appropriate platform-specific dirs"
HOMEPAGE="
	https://github.com/ActiveState/appdirs/
	https://pypi.org/project/appdirs/
"
SRC_URI="
	https://github.com/ActiveState/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"

python_test() {
	"${EPYTHON}" test/test_api.py -v || die "Tests fail with ${EPYTHON}"
}
