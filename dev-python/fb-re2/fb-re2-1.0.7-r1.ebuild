# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..12} )

inherit distutils-r1

MY_P=pyre2-${PV}
DESCRIPTION="Python bindings for dev-libs/re2"
HOMEPAGE="
	https://github.com/facebook/pyre2/
	https://pypi.org/project/fb-re2/
"
SRC_URI="
	https://github.com/facebook/pyre2/archive/v${PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

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

src_prepare() {
	# py3.12
	# https://github.com/facebook/pyre2/pull/26
	sed -e 's:assertRaisesRegexp:assertRaisesRegex:' \
		-i tests/test_match.py || die
	distutils-r1_src_prepare
}
