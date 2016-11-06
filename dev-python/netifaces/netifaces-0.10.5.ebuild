# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_{4,5}} pypy{,3} )

inherit distutils-r1

DESCRIPTION="Portable network interface information"
HOMEPAGE="
	https://pypi.python.org/pypi/netifaces/
	http://alastairs-place.net/netifaces/
	https://bitbucket.org/al45tair/netifaces"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""

PATCHES=( "${FILESDIR}"/${PN}-0.10.4-remove-osx-fix.patch )
