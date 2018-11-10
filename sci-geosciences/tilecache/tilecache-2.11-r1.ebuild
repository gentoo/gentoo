# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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

RDEPEND="dev-python/pillow
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
