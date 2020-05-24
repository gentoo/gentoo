# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=rdepend
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1 git-r3

DESCRIPTION="Remove outdated built kernels"
HOMEPAGE="https://github.com/mgorny/eclean-kernel/"
EGIT_REPO_URI="https://github.com/mgorny/eclean-kernel.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="kernel_linux? ( dev-python/pymountboot[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest
