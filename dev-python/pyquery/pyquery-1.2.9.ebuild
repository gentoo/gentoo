# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pyquery/pyquery-1.2.9.ebuild,v 1.10 2015/05/31 11:07:56 maekke Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="A jQuery-like library for python"
HOMEPAGE="https://github.com/gawel/pyquery"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~hppa ppc ppc64 x86"
IUSE="beautifulsoup3 test"

RDEPEND=">=dev-python/lxml-2.1[beautifulsoup3?,${PYTHON_USEDEP}]
	>dev-python/cssselect-0.7.9[${PYTHON_USEDEP}]
	>=dev-python/webob-1.1.9[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	app-arch/unzip
	test? ( ${RDEPEND}
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/webtest[${PYTHON_USEDEP}] )"

REQUIRED_USE="test? ( beautifulsoup3 )"

python_test() {
	# The suite, it appears, requires this hard setting of PYTHONPATH!
	PYTHONPATH=. nosetests || die "Tests fail with ${EPYTHON}"
}
