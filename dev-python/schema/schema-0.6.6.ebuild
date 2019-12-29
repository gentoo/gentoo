# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{5,6} pypy3 )

inherit distutils-r1

DESCRIPTION="Library for validating Python data structures"
HOMEPAGE="https://pypi.org/project/schema/ https://github.com/keleshev/schema"
SRC_URI="
	mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz
	https://github.com/keleshev/schema/archive/v${PV}.zip -> ${P}.tar.gz
"

SLOT="0"
LICENSE="MIT"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
