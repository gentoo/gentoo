# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..8} )

inherit distutils-r1

MY_PV=$(ver_rs 2 '-')

DESCRIPTION="A python3 CLI utility to interface with cpy.pt paste service"
HOMEPAGE="https://github.com/lbatalha/capyt
	https://pypi.org/project/capyt/"
SRC_URI="https://github.com/lbatalha/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	${DEPEND}
	dev-python/requests[${PYTHON_USEDEP}]
"

S="${WORKDIR}/${PN}-${MY_PV}"
