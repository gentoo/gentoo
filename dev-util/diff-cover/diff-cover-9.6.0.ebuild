# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..13} )
inherit distutils-r1

DESCRIPTION="Find diff lines that do not have test coverage"
HOMEPAGE="https://github.com/Bachmann1234/diff_cover"
SRC_URI="https://github.com/Bachmann1234/diff_cover/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/diff_cover-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/jinja2-2.7.1[${PYTHON_USEDEP}]
	>=dev-python/pluggy-0.13.1[${PYTHON_USEDEP}]
	>=dev-python/chardet-3.0.0[${PYTHON_USEDEP}]
"
# Note: flake8/pylint called as shell tools, not imported libraries
BDEPEND="
	test? (
		dev-python/flake8
		dev-python/pylint
		dev-python/pytest-datadir[${PYTHON_USEDEP}]
		dev-python/pytest-mock[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
