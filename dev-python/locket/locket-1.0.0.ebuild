# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_P=locket.py-${PV}
DESCRIPTION="File-based locks for Python"
HOMEPAGE="
	https://github.com/mwilliamson/locket.py/
	https://pypi.org/project/locket/
"
SRC_URI="
	https://github.com/mwilliamson/locket.py/archive/${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~riscv x86 ~amd64-linux ~x86-linux"

BDEPEND="
	test? ( dev-python/spur[${PYTHON_USEDEP}] )
"

distutils_enable_tests pytest
