# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_PN="notofonttools"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Noto fonts support tools and scripts plus web site generation"
HOMEPAGE="https://github.com/googlefonts/nototools"
#SRC_URI="https://github.com/googlefonts/nototools/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 OFL-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"

RDEPEND="
	>=media-gfx/scour-0.37
	>=dev-python/booleanOperations-0.9.0[${PYTHON_USEDEP}]
	>=dev-python/defcon-0.6.0[${PYTHON_USEDEP}]
	>=dev-python/fonttools-4.11.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-8.3.2[${PYTHON_USEDEP}]
	>=dev-python/pyclipper-1.2.1[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${MY_P}"

# Some tests weren't ported to python3 yet and lots of failures
RESTRICT="test"

distutils_enable_tests setup.py
