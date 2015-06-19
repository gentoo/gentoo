# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyev/pyev-0.8.1.ebuild,v 1.9 2015/06/07 09:34:50 maekke Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

MY_P=${P}-4.04

DESCRIPTION="Python libev interface, an event loop"
HOMEPAGE="http://code.google.com/p/pyev/
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
