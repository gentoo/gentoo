# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="A trivial extension that just raises an exception (for testing)"
HOMEPAGE="
	https://pypi.org/project/cython-test-exception-raiser/
	https://github.com/twisted/cython-test-exception-raiser/"
SRC_URI="
	https://github.com/twisted/cython-test-exception-raiser/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~sparc ~x86"

BDEPEND="dev-python/cython[${PYTHON_USEDEP}]"
