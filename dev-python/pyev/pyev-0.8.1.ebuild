# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4} )

inherit distutils-r1

MY_P=${P}-4.04

DESCRIPTION="Python libev interface, an event loop"
HOMEPAGE="https://code.google.com/p/pyev/
	http://pythonhosted.org/pyev/"
SRC_URI="mirror://pypi/p/pyev/${MY_P}.tar.gz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="amd64 arm x86"
IUSE=""

RDEPEND="dev-libs/libev
	dev-python/setuptools[${PYTHON_USEDEP}]
	${PYTHON_DEPS}"

DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

HTML_DOCS=( doc/. )

python_prepare() {
	distutils-r1_python_prepare
}
