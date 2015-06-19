# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/tornado/tornado-4.2.0_beta1.ebuild,v 1.2 2015/06/07 09:08:31 maekke Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1 vcs-snapshot

MY_PV=${PV/.0_beta/b}

DESCRIPTION="Tornado is a Python web framework and asynchronous networking library, ... ."
HOMEPAGE="http://www.tornadoweb.org/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${PN}-${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc examples test"

CDEPEND="
	dev-python/certifi[${PYTHON_USEDEP}]
	>=dev-python/pycurl-7.18.2[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/asyncio[${PYTHON_USEDEP}]' 'python3_3')
	$(python_gen_cond_dep 'dev-python/backports-ssl-match-hostname[${PYTHON_USEDEP}]' 'python2_7')
	$(python_gen_cond_dep 'dev-python/futures[${PYTHON_USEDEP}]' 'python2_7 pypy')
	$(python_gen_cond_dep 'dev-python/singledispatch[${PYTHON_USEDEP}]' 'python2_7 python3_3')
	$(python_gen_cond_dep 'dev-python/twisted-names[${PYTHON_USEDEP}]' 'python2_7')
	$(python_gen_cond_dep 'dev-python/twisted-web[${PYTHON_USEDEP}]' 'python2_7')
"
# dev-python/twisted-* only supports python2_7 currently
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? (
		dev-python/sphinx[${PYTHON_USEDEP}]
		dev-python/sphinx_rtd_theme[${PYTHON_USEDEP}]
	)
	test? (
		${CDEPEND}
		$(python_gen_cond_dep 'dev-python/mock[${PYTHON_USEDEP}]' python2_7 pypy)
	)
"
RDEPEND="${CDEPEND}"

python_prepare_all() {
	local PATCHES=(
		"${FILESDIR}"/drop-intersphinx.patch
	)

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs sphinx
}

python_test() {
	"${PYTHON}" -m tornado.test.runtests || die "tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )
	use examples && local EXAMPLES=( demos/. )

	distutils-r1_python_install_all
}
