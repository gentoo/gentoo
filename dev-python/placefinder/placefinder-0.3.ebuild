# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

MY_PN="${PN}"-py

DESCRIPTION="Yahoo! BOSS PlaceFinder Python Client"
HOMEPAGE=" https://github.com/adampresley/placefinder-py"
SRC_URI="mirror://pypi/${PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

S="${WORKDIR}/${MY_PN}-${PV}"
