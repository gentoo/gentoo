# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

inherit distutils-r1

MY_P="${P//_p/.post}"
DESCRIPTION="Iterative JSON parser with a Pythonic interface"
HOMEPAGE="
	https://github.com/ICRAR/ijson/
	https://pypi.org/project/ijson/
"
SRC_URI="
	https://github.com/ICRAR/${PN}/archive/v${PV/_p/.post}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"

DEPEND="
	dev-libs/yajl
"
RDEPEND="
	${DEPEND}
"

distutils_enable_tests pytest
