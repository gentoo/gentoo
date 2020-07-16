# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

MY_PN="SquareMap"
MY_P="${MY_PN}-${PV/_beta/b}"

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Hierarchic data-visualisation control for wxPython"
HOMEPAGE="https://pypi.org/project/SquareMap/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-python/wxpython:3.0"

S="${WORKDIR}"/${MY_P}
