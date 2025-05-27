# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{11..14} )
inherit distutils-r1

DESCRIPTION="A command-line tool for seeing the latest in space"
HOMEPAGE="https://github.com/gideonshaked/nextinspace"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/gideonshaked/nextinspace.git"
else
	SRC_URI="https://github.com/gideonshaked/nextinspace/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=dev-python/colorama-0.4.3[${PYTHON_USEDEP}]
	>=dev-python/requests-2.24[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest-lazy-fixtures[${PYTHON_USEDEP}]
		>=dev-python/requests-mock-1.8[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
