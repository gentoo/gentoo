# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7} )

inherit distutils-r1

DESCRIPTION="A Python wrapper around the RIPE Atlas API"
HOMEPAGE="https://atlas.ripe.net/"
MY_GITHUB_AUTHOR="RIPE-NCC"
SRC_URI="https://github.com/${MY_GITHUB_AUTHOR}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( CHANGES.rst README.rst )

RDEPEND="
	<dev-python/websocket-client-0.99[${PYTHON_USEDEP}]
	>=dev-python/requests-2.7.0[${PYTHON_USEDEP}]
	>=dev-python/socketio-client-0.6.5[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
"
DEPEND="
	test? (
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-python/funcsigs[${PYTHON_USEDEP}]
		dev-python/jsonschema[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
	)
	${RDEPEND}
"

distutils_enable_tests nose
distutils_enable_sphinx docs
