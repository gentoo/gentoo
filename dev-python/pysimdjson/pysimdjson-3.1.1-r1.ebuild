# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
inherit distutils-r1

DESCRIPTION="Python bindings for simdjson"
HOMEPAGE="https://github.com/TkTech/pysimdjson"
SRC_URI="https://github.com/TkTech/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/simdjson
"
BDEPEND="
	>=dev-python/pybind11-2.6.1[${PYTHON_USEDEP}]
"
distutils_enable_tests pytest
