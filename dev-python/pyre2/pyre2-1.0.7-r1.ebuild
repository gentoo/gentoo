# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..11} )

inherit distutils-r1

DESCRIPTION="Python bindings for dev-libs/re2"
HOMEPAGE="
	https://github.com/facebook/pyre2/
	https://pypi.org/project/fb-re2/
"
SRC_URI="
	https://github.com/facebook/pyre2/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/re2:=
"
RDEPEND="
	${DEPEND}
"

distutils_enable_tests unittest
