# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/asset/asset-0.6.1-r1.ebuild,v 1.1 2015/08/04 10:03:27 jlec Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} )

inherit distutils-r1

DESCRIPTION="A package resource and symbol loading helper library"
HOMEPAGE="https://pypi.python.org/pypi/asset http://github.com/metagriffin/asset"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3+"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	>=dev-python/globre-0.0.5[${PYTHON_USEDEP}]
	>=dev-python/six-1.4.1[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		>=dev-python/nose-1.3.0[${PYTHON_USEDEP}]
		>=dev-python/pxml-0.2.11[${PYTHON_USEDEP}]
	)"

PATCHES=( "${FILESDIR}"/${P}-broken-test.patch )

python_prepare_all() {
	sed \
		-e '/distribute/d' \
		-i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	nosetests --verbose || die
}
