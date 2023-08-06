# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

MY_PN="python-glyr"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A python wrapper for Glyr"
HOMEPAGE="
	https://sahib.github.io/python-glyr/intro.html
	https://github.com/sahib/python-glyr/
	https://pypi.org/project/plyr/
"
SRC_URI="
	https://github.com/sahib/${MY_PN}/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+"
KEYWORDS="amd64 x86"
SLOT="0"

DEPEND="
	media-libs/glyr:=
"
RDEPEND="
	${DEPEND}
"
# <cython-3: https://bugs.gentoo.org/898696
BDEPEND="
	<dev-python/cython-3[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs/source
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# Internet
	tests/test_misc.py::TestMisc::test_download
)
