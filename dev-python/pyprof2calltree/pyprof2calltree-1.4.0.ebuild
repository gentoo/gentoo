# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_6 )

inherit distutils-r1

DESCRIPTION="convert python profile data to kcachegrind calltree form"
HOMEPAGE="https://pypi.org/project/pyprof2calltree/"
# pypi tarball lacks tests
SRC_URI="https://github.com/pwaller/pyprof2calltree/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

PATCHES=(
	"${FILESDIR}"/pyprof2calltree-1.4.0-py3-test.patch
)

python_test() {
	"${PYTHON}" -m tests.test_integration || die "Tests fail with ${EPYTHON}"
}
