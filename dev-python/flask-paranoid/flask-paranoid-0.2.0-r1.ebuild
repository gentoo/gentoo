# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python3_{7,8,9} )
inherit distutils-r1

MY_PV=$(ver_cut 1-2)

DESCRIPTION="Simple user session protection extension for Flask"
HOMEPAGE="https://github.com/miguelgrinberg/flask-paranoid/"
SRC_URI="https://github.com/miguelgrinberg/${PN}/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RESTRICT="!test? ( test )"

RDEPEND="dev-python/flask[${PYTHON_USEDEP}]"

S="${WORKDIR}/${PN}-${MY_PV}"

distutils_enable_tests setup.py
