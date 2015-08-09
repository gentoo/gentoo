# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1

DESCRIPTION="Lightweight SOAP client (Jurko's fork) (py3 support) (active development)"
HOMEPAGE="http://bitbucket.org/jurko/suds"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}-jurko/${PN}-jurko-${PV}.tar.bz2 -> ${P}.tar.bz2"
S="${WORKDIR}/${PN}-jurko-${PV}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_prepare() {
	rm -R tests
}

python_compile() {
	distutils-r1_python_compile
	mv suds_jurko.egg-info suds.egg-info || die
	sed -i -e 's/Name\:\ suds-jurko/Name:\ suds/g' -e '/^Obsoletes/d' suds.egg-info/PKG-INFO || die
}
