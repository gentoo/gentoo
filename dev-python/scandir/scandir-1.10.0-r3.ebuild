# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
# Do NOT add Python 3.11 without verifying the C extension is actually built
# and installed for it!
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

DESCRIPTION="A better directory iterator and faster os.walk()"
HOMEPAGE="https://github.com/benhoyt/scandir"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

PATCHES=(
	"${FILESDIR}"/${P}-python3.9.patch
)

python_test() {
	"${EPYTHON}" test/run_tests.py -v || die "tests failed under ${EPYTHON}"
}
