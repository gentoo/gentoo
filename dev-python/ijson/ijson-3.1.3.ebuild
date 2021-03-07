# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} pypy3 )
inherit distutils-r1

MY_PV="${PV//_p/.post}"
DESCRIPTION="Iterative JSON parser with a Pythonic interface"
HOMEPAGE="
	https://github.com/ICRAR/ijson
	https://pypi.org/project/ijson/
"
SRC_URI="https://github.com/ICRAR/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-libs/yajl"
DEPEND="${RDEPEND}"

distutils_enable_tests pytest
