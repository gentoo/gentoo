# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_8 )

inherit distutils-r1

DESCRIPTION="Remove outdated built kernels"
HOMEPAGE="https://github.com/projg2/eclean-kernel/"
SRC_URI="https://github.com/projg2/eclean-kernel/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="kernel_linux? ( dev-python/pymountboot[${PYTHON_USEDEP}] )"
