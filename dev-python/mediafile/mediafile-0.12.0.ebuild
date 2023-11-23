# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

DESCRIPTION="Read and write audio files' tags in Python"
HOMEPAGE="
	https://github.com/beetbox/mediafile/
	https://pypi.org/project/mediafile/
"
SRC_URI="
	https://github.com/beetbox/mediafile/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/six-1.9.0[${PYTHON_USEDEP}]
	>=media-libs/mutagen-1.46.0[${PYTHON_USEDEP}]
"

distutils_enable_sphinx docs
distutils_enable_tests unittest
