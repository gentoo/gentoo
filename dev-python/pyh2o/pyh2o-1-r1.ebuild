# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Python API for sci-libs/libh2o"
HOMEPAGE="https://github.com/mgorny/pyh2o/"
SRC_URI="
	https://github.com/mgorny/pyh2o/archive/v${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=sci-libs/libh2o-0.2.1:=
"
DEPEND="
	${RDEPEND}
"

distutils_enable_tests pytest
