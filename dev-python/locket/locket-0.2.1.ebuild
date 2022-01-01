# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

MY_P=locket.py-${PV}
DESCRIPTION="File-based locks for Python"
HOMEPAGE="https://github.com/mwilliamson/locket.py"
SRC_URI="
	https://github.com/mwilliamson/locket.py/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86 ~amd64-linux ~x86-linux"

BDEPEND="
	test? ( dev-python/spur[${PYTHON_USEDEP}] )"

distutils_enable_tests nose
