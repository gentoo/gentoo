# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )
inherit eutils distutils-r1

DESCRIPTION="Enables iconic fonts such as Font Awesome in PyQt"
HOMEPAGE="https://github.com/spyder-ide/qtawesome/ https://pypi.python.org/pypi/QtAwesome/"
MY_PN="QtAwesome"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-fonts/fontawesome"
DEPEND=""

S="${WORKDIR}/${MY_P}"
