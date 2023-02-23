# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 git-r3

DESCRIPTION="Remove outdated built kernels"
HOMEPAGE="https://github.com/projg2/eclean-kernel/"
EGIT_REPO_URI="https://github.com/projg2/eclean-kernel.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="lz4 lzo zstd"

RDEPEND="
	kernel_linux? ( dev-python/pymountboot[${PYTHON_USEDEP}] )
	lz4? ( dev-python/lz4[${PYTHON_USEDEP}] )
	lzo? ( dev-python/python-lzo[${PYTHON_USEDEP}] )
	zstd? ( dev-python/zstandard[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest
