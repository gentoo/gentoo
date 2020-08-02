# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..8} )

inherit distutils-r1

DESCRIPTION="Command-line utility to create projects from cookiecutters (project templates)"
HOMEPAGE="https://github.com/audreyr/cookiecutter"

SRC_URI="https://github.com/audreyr/cookiecutter/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=">=dev-python/binaryornot-0.4.4[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.7[${PYTHON_USEDEP}]
	<dev-python/jinja-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/click-7.0[${PYTHON_USEDEP}]
	>=dev-python/poyo-0.5.0[${PYTHON_USEDEP}]
	>=dev-python/jinja2-time-0.2.0[${PYTHON_USEDEP}]
	dev-python/python-slugify[${PYTHON_USEDEP}]
	>=dev-python/requests-2.23.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10[${PYTHON_USEDEP}]
	<dev-python/markupsafe-2.0.0[${PYTHON_USEDEP}]
	dev-python/setuptools[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-vcs/git )"

DOCS=( README.md HISTORY.md CONTRIBUTING.md )

PATCHES=(
	"${FILESDIR}/test_cli-1.7.2.patch"
	)

python_test() {
	pytest -o addopts= || die
}
