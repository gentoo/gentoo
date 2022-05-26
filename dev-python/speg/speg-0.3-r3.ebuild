# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1
DESCRIPTION="A PEG-based parser interpreter with memoization"
HOMEPAGE="https://github.com/avakar/speg/"
SRC_URI="https://github.com/avakar/speg/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~ppc ~riscv ~x86"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""
