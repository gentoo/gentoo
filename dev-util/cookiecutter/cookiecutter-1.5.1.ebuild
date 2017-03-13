# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit vcs-snapshot distutils-r1

DESCRIPTION="Command-line utility to create projects from cookiecutters (project templates)"
HOMEPAGE="https://github.com/audreyr/cookiecutter"

SRC_URI="https://github.com/audreyr/cookiecutter/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RESTRICT="test" # tests currently fail here

RDEPEND=">=dev-python/binaryornot-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/future-0.15.2[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.7[${PYTHON_USEDEP}]
	>=dev-python/click-5.0[${PYTHON_USEDEP}]
	>=dev-python/whichcraft-0.1.1[${PYTHON_USEDEP}]
	>=dev-python/poyo-0.4.0[${PYTHON_USEDEP}]
	>=dev-python/jinja2-time-0.1.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		>=dev-python/pytest-mock-1.1[${PYTHON_USEDEP}]
		dev-python/pytest-capturelog[${PYTHON_USEDEP}]
		dev-python/freezegun[${PYTHON_USEDEP}] )"

DOCS=( README.rst HISTORY.rst CONTRIBUTING.rst )

python_test() {
	py.test || die
}
