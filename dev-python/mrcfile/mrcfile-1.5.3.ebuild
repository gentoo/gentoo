# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )

inherit distutils-r1

DESCRIPTION="MRC2014 file format I/O library"
HOMEPAGE="
	https://pypi.org/project/mrcfile/
	https://github.com/ccpem/mrcfile/
"
SRC_URI="
	https://github.com/ccpem/mrcfile/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	>=dev-python/numpy-1.16.0[${PYTHON_USEDEP}]
"

distutils_enable_tests unittest
