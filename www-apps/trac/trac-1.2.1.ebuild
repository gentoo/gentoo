# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='sqlite?'

DISTUTILS_SINGLE_IMPL=Yes

inherit distutils-r1 eutils user webapp

MY_PV=${PV/_p/.post}
MY_P=Trac-${MY_PV}

DESCRIPTION="Enhanced wiki and issue tracking system for software development projects"
HOMEPAGE="http://trac.edgewall.com/ https://pypi.org/project/Trac"
SRC_URI="http://ftp.edgewall.com/pub/trac/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="cgi fastcgi i18n +highlight +restructuredtext mysql postgres +sqlite subversion test"
REQUIRED_USE="|| ( mysql postgres sqlite )"

RDEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/genshi[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
	i18n? ( >=dev-python/Babel-0.9.5[${PYTHON_USEDEP}] )
	highlight? (
		|| (
			dev-python/pygments[${PYTHON_USEDEP}]
			app-text/silvercity
			app-text/pytextile
			app-text/enscript
		)
	)
	restructuredtext? ( dev-python/docutils[${PYTHON_USEDEP}] )
	mysql? ( dev-python/mysql-python[${PYTHON_USEDEP}] )
	postgres? ( >=dev-python/psycopg-2[${PYTHON_USEDEP}] )
	sqlite? ( >=dev-db/sqlite-3.3.4:3 )
	subversion? ( dev-vcs/subversion[python,${PYTHON_USEDEP}] )
	"
DEPEND="${RDEPEND}
	test? (
		dev-python/twill[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/configobj[${PYTHON_USEDEP}]
	)"

S="${WORKDIR}/${MY_P}"

WEBAPP_MANUAL_SLOT="yes"

pkg_setup() {
	python-single-r1_pkg_setup
	webapp_pkg_setup

	enewgroup tracd
	enewuser tracd -1 -1 -1 tracd
}

python_prepare_all() {
	distutils-r1_python_prepare_all
}

src_test() {
	distutils-r1_src_test
}

python_test() {
	PYTHONPATH=. "${PYTHON}" trac/test.py || die "Tests fail with ${EPYTHON}"
}

python_test_all() {
	if use i18n; then
		make check
	fi
}

# the default src_compile just calls setup.py build
# currently, this switches i18n catalog compilation based on presence of Babel

src_install() {
	webapp_src_preinst
	distutils-r1_src_install

	# project environments might go in here
	keepdir /var/lib/trac

	# Use this as the egg-cache for tracd
	dodir /var/lib/trac/egg-cache
	keepdir /var/lib/trac/egg-cache
	fowners tracd:tracd /var/lib/trac/egg-cache

	# documentation
	dodoc -r contrib

	# tracd init script
	newconfd "${FILESDIR}"/tracd.confd tracd
	newinitd "${FILESDIR}"/tracd.initd tracd

	for lang in en; do
		webapp_postinst_txt ${lang} "${FILESDIR}"/postinst-${lang}.txt
		webapp_postupgrade_txt ${lang} "${FILESDIR}"/postupgrade-${lang}.txt
	done

	webapp_src_install
}

pkg_postinst() {
	webapp_pkg_postinst
}
