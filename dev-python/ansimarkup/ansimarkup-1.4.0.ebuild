# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1

DESCRIPTION="XML-like markup for producing colored terminal text"
HOMEPAGE="https://github.com/gvalkov/python-ansimarkup"
SRC_URI="https://github.com/gvalkov/python-${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/colorama[${PYTHON_USEDEP}]
"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		${RDEPEND}
		>=dev-python/pytest-3.0.3[${PYTHON_USEDEP}]
	)
"

S="${WORKDIR}/python-${P}"

python_test() {
	pytest -v || die "Tests failed with ${EPYTHON}"
}
