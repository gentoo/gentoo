# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=poetry
PYTHON_COMPAT=( python3_{10..12} )
inherit distutils-r1

DESCRIPTION="Find diff lines that do not have test coverage"
HOMEPAGE="https://github.com/Bachmann1234/diff_cover"
SRC_URI="https://github.com/Bachmann1234/${PN/-/_}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/${P/diff-cover/diff_cover}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="test"

RDEPEND="
	dev-python/pygments[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.7.1[${PYTHON_USEDEP}]
	>=dev-python/pluggy-0.13.1[${PYTHON_USEDEP}]
	>=dev-python/chardet-3.0.0[${PYTHON_USEDEP}]
	>=dev-python/tomli-1.2.1
"
BDEPEND="test? ( dev-python/mock[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest
