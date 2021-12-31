# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE='sqlite?'

DISTUTILS_SINGLE_IMPL=Yes
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1 eutils user webapp

MY_PV=${PV/_p/.post}
MY_P=Trac-${MY_PV}

DESCRIPTION="Enhanced wiki and issue tracking system for software development projects"
HOMEPAGE="https://trac.edgewall.com/ https://pypi.org/project/Trac/"
SRC_URI="https://download.edgewall.org/trac/Trac-${MY_PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="cgi fastcgi i18n +highlight +restructuredtext mysql postgres +sqlite subversion"
REQUIRED_USE="|| ( mysql postgres sqlite )"

RDEPEND="
	$(python_gen_cond_dep '
		dev-python/setuptools[${PYTHON_MULTI_USEDEP}]
		dev-python/genshi[${PYTHON_MULTI_USEDEP}]
		dev-python/pytz[${PYTHON_MULTI_USEDEP}]
		i18n? ( >=dev-python/Babel-0.9.5[${PYTHON_MULTI_USEDEP}] )
		highlight? (
			|| (
				dev-python/pygments[${PYTHON_MULTI_USEDEP}]
				app-text/silvercity
				app-text/pytextile
				app-text/enscript
			)
		)
		restructuredtext? ( dev-python/docutils[${PYTHON_MULTI_USEDEP}] )
		mysql? ( dev-python/mysql-python[${PYTHON_MULTI_USEDEP}] )
		postgres? ( >=dev-python/psycopg-2[${PYTHON_MULTI_USEDEP}] )
		sqlite? ( >=dev-db/sqlite-3.3.4:3 )
		subversion? ( dev-vcs/subversion[python,${PYTHON_MULTI_USEDEP}] )
	')
	"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

# Tests depend on twill, a broken package
RESTRICT="test"

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
