# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} pypy )
inherit distutils-r1

DESCRIPTION="Logging as Storytelling"
HOMEPAGE="https://github.com/hybridcluster/${PN}"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/sphinx[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )"
RDEPEND="
	dev-python/six[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]
	"

python_compile_all() {
	emake -C "${S}/docs" man
	use doc && emake -C "${S}/docs" html
}

python_install_all() {
	doman "${S}/docs/build/man/"*
	use doc && dohtml -r "${S}/docs/build/html/"*
}

python_test() {
	py.test || die "Tests fail with ${EPYTHON}"
}
