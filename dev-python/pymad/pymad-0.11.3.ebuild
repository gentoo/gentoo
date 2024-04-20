# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Python wrapper for libmad MP3 decoding in python"
HOMEPAGE="
	https://github.com/jaqx0r/pymad/
	https://pypi.org/project/pymad/
"
SRC_URI="
	https://github.com/jaqx0r/pymad/releases/download/v${PV}/${P}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 ~ppc ~x86"

DEPEND="media-libs/libmad"
RDEPEND="${DEPEND}"

distutils_enable_tests pytest
