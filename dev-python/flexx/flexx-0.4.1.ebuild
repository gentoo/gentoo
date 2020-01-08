# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 )

inherit distutils-r1

DESCRIPTION="Pure Python toolkit for creating GUI's using web technology"
HOMEPAGE="
	https://flexx.readthedocs.org
	https://github.com/zoofio/flexx
	https://pypi.org/project/flexx/"
SRC_URI="https://github.com/zoofIO//${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

#IUSE="doc test" broken tests
IUSE=""
RDEPEND="www-servers/tornado[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
