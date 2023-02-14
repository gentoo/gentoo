# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Command-line utility to create projects from cookiecutters (project templates)"
HOMEPAGE="https://github.com/cookiecutter/cookiecutter"
SRC_URI="https://github.com/cookiecutter/cookiecutter/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"

RDEPEND="
	>=dev-python/binaryornot-0.4.4[${PYTHON_USEDEP}]
	>=dev-python/click-7.0[${PYTHON_USEDEP}]
	<dev-python/click-9.0.0[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.7[${PYTHON_USEDEP}]
	<dev-python/jinja-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/jinja2-time-0.2.0[${PYTHON_USEDEP}]
	>=dev-python/python-slugify-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/requests-2.23.0[${PYTHON_USEDEP}]
"

BDEPEND="
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

DOCS=( README.md HISTORY.md CONTRIBUTING.md )

PATCHES=(
	"${FILESDIR}/test_cli-1.7.2.patch"
	# https://github.com/cookiecutter/cookiecutter/issues/1655
	"${FILESDIR}/${P}-fix-path-in-test.patch"
	# https://github.com/cookiecutter/cookiecutter/pull/1643
	"${FILESDIR}/${P}-relax-click-dependency.patch"
)

distutils_enable_tests pytest
# TODO: Package sphinx-click
# distutils_enable_sphinx docs \
# 	dev-python/sphinx-rtd-theme \
# 	dev-python/recommonmark

python_test() {
	epytest -o addopts=
}
