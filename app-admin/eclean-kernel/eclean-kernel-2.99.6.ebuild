# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1 pypi

DESCRIPTION="Remove outdated built kernels"
HOMEPAGE="
	https://github.com/projg2/eclean-kernel/
	https://pypi.org/project/eclean-kernel/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"
IUSE="lz4 lzo zstd"

RDEPEND="
	kernel_linux? ( dev-python/pymountboot[${PYTHON_USEDEP}] )
	lz4? ( dev-python/lz4[${PYTHON_USEDEP}] )
	lzo? ( dev-python/python-lzo[${PYTHON_USEDEP}] )
	zstd? ( dev-python/zstandard[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest
