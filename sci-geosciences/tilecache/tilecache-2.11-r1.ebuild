# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-geosciences/tilecache/tilecache-2.11-r1.ebuild,v 1.2 2015/04/08 18:49:16 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Web map tile caching system"
HOMEPAGE="http://tilecache.org/"
SRC_URI="http://${PN}.org/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/python-imaging
	dev-python/paste"
DEPEND="${RDEPEND}
	dev-python/setuptools
"

PATCHES=( "${FILESDIR}/tilecache-2.11-pil.patch" )

src_install() {
	distutils-r1_src_install "--debian"
}

python_test() {
	python setup.py test || die "Failed tests"
}
