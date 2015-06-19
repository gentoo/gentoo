# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/jsonpatch/jsonpatch-1.9.ebuild,v 1.3 2015/03/08 23:51:44 pacho Exp $

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Apply JSON-Patches according to
	http://tools.ietf.org/html/draft-pbryan-json-patch-04"
HOMEPAGE="https://github.com/stefankoegl/python-json-patch"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/jsonpointer-1.5[${PYTHON_USEDEP}]"

python_test() {
	"${PYTHON}" tests.py || die "Tests fail with ${EPYTHON}"
	"${PYTHON}" ext_tests.py || die "Tests fail with ${EPYTHON}"
}
