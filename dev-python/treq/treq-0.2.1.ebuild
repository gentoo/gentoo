# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/treq/treq-0.2.1.ebuild,v 1.3 2015/04/08 08:05:23 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Python requests like API built on top of Twisted's HTTP client."
HOMEPAGE="https://github.com/dreid/${PN}"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc test"

COMMON_DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="${COMMON_DEPEND}
	>=dev-python/pyopenssl-0.11[${PYTHON_USEDEP}]
	>=dev-python/twisted-core-12.1.0[${PYTHON_USEDEP}]
	>=dev-python/twisted-web-12.1.0[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/service_identity[${PYTHON_USEDEP}]"

DEPEND="${COMMON_DEPEND}
	doc? ( dev-python/sphinx
		${RDEPEND} )
	test? ( dev-python/mock[${PYTHON_USEDEP}] )"

python_compile_all() {
	use doc && emake -C "${S}/docs" html
}

python_install_all() {
	 use doc && dohtml -r "${S}/docs/_build/html/"*
}

python_test() {
	trial treq || die "Tests fail with ${EPYTHON}"
}
