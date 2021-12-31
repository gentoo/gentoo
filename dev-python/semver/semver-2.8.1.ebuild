# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="A Python module for semantic versioning"
HOMEPAGE="https://github.com/k-bx/python-semver"
SRC_URI="https://github.com/k-bx/python-${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (	dev-python/pytest[${PYTHON_USEDEP}]	)
"

RDEPEND=""

DEPEND="${RDEPEND}"

S="${WORKDIR}/python-${P}"

python_test() {
	pytest -v || die "Tests failed with ${EPYTHON}"
}
