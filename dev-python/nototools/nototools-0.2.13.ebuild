# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

MY_PN="notofonttools"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Noto fonts support tools and scripts plus web site generation"
HOMEPAGE="https://github.com/googlefonts/nototools"
#SRC_URI="https://github.com/googlefonts/nototools/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 OFL-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"

RDEPEND="
	media-gfx/scour
	>=dev-python/booleanOperations-0.7.0[${PYTHON_USEDEP}]
	>=dev-python/defcon-0.3.1[${PYTHON_USEDEP}]
	>=dev-python/fonttools-3.36.0[${PYTHON_USEDEP}]
	>=dev-python/pillow-4.0.0[${PYTHON_USEDEP}]
	>=dev-python/pyclipper-1.0.6[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${MY_P}"

# Some tests weren't ported to python3 yet and lots of failures
RESTRICT="test"

distutils_enable_tests setup.py
