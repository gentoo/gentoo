# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=7
PYTHON_COMPAT=( python3_{6,7} )
inherit distutils-r1
DESCRIPTION="A PEG-based parser interpreter with memoization"
HOMEPAGE="https://github.com/avakar/speg/"
SRC_URI="https://github.com/avakar/speg/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0"
LICENSE="MIT"
KEYWORDS="amd64 ~x86"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""
