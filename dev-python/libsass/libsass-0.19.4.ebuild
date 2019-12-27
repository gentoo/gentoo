# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="A straightforward binding of libsass for Python"
HOMEPAGE="https://github.com/sass/libsass-python"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="dev-libs/libsass
		dev-python/six[${PYTHON_USEDEP}]
		test? ( dev-python/PyQt5[testlib,${PYTHON_USEDEP}] )"

# Remove sassc, in favour of pysassc, see: https://github.com/sass/libsass-python/issues/134
# This avoids a file collision with dev-lang/sassc
PATCHES=( "${FILESDIR}"/${P}_rename_sassc.patch )

python_test() {
	"${EPYTHON}" sasstests.py || die "Tests fail with ${EPYTHON}"
}
