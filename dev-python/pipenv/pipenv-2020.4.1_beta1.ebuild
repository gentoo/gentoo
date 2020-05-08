# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

MY_PV=${PV/_beta/b}
DESCRIPTION="Python Development Workflow for Humans"
HOMEPAGE="https://github.com/pypa/pipenv https://pypi.org/project/pipenv/"
SRC_URI="https://github.com/pypa/pipenv/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/pip-18.0[${PYTHON_USEDEP}]
	dev-python/virtualenv[${PYTHON_USEDEP}]
	>=dev-python/virtualenv-clone-0.2.5[${PYTHON_USEDEP}]
	>=dev-python/setuptools-36.2.1[${PYTHON_USEDEP}]"
DEPEND="test? (
		${RDEPEND}
		dev-python/flaky[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		<dev-python/pytest-5[${PYTHON_USEDEP}]
		dev-python/pytest-timeout[${PYTHON_USEDEP}]
		dev-python/pytest-xdist[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)"

RESTRICT="!test? ( test )"

S="${WORKDIR}"/${PN}-${MY_PV}

PATCHES=(
	"${FILESDIR}/${PN}-2020.4.1_beta1-disable-networked-tests.patch"
)

python_test() {
	pytest -m "not cli" -vv tests/unit || die
}
