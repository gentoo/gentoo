# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="A collection of utilities and processors for the Python Imaging Libary"
HOMEPAGE="https://github.com/matthewwithanm/pilkit"
SRC_URI="https://github.com/matthewwithanm/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/pillow[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP},jpeg,zlib]
	)"

distutils_enable_tests nose
