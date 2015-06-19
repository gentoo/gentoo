# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-social-auth/python-social-auth-0.1.26.ebuild,v 1.4 2015/03/06 22:35:17 pacho Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="Easy to setup social auth mechanism with support for several frameworks and auth providers"
HOMEPAGE="http://psa.matiasaguirre.net/"
SRC_URI="https://github.com/omab/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"
IUSE="doc examples test"

RDEPEND="
	$(python_gen_cond_dep \
	    'dev-python/python-openid[${PYTHON_USEDEP}]' 'python2*')
	$(python_gen_cond_dep \
		'dev-python/python3-openid[${PYTHON_USEDEP}]' 'python3*')
	>=dev-python/oauthlib-0.3.8[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/requests-oauthlib[${PYTHON_USEDEP}]
	>=dev-python/six-1.2.0[${PYTHON_USEDEP}]
"
DEPEND="${DEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"
# tests require internet
#"
#	test? (
#		dev-python/coverage[${PYTHON_USEDEP}]
#		dev-python/httpretty[${PYTHON_USEDEP}]
#		dev-python/mock[${PYTHON_USEDEP}]
#		dev-python/nose[${PYTHON_USEDEP}]
#		dev-python/sure[${PYTHON_USEDEP}]
#	)
#"

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}

#python_test() {
#	"${S}"/social/tests/run_tests.sh || die "Tests failed on ${EPYTHON}"
#}
