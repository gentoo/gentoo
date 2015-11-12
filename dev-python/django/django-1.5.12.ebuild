# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3} pypy )
PYTHON_REQ_USE='sqlite?,threads(+)'
WEBAPP_NO_AUTO_INSTALL="yes"

inherit bash-completion-r1 distutils-r1 versionator webapp

MY_P="Django-${PV}"

DESCRIPTION="High-level Python web framework"
HOMEPAGE="http://www.djangoproject.com/ https://pypi.python.org/pypi/Django"
SRC_URI="https://www.djangoproject.com/m/releases/$(get_version_component_range 1-2)/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="doc mysql postgres sqlite test"

PY2_USEDEP=$(python_gen_usedep python2_7)
PY23_USEDEP=$(python_gen_usedep python2_7 'python{3_3,3_4}')
RDEPEND="dev-python/pillow[${PYTHON_USEDEP}]
	postgres? ( dev-python/psycopg:2[${PY23_USEDEP}] )
	mysql? ( >=dev-python/mysql-python-1.2.3[${PY2_USEDEP}] )"
DEPEND="${RDEPEND}
	doc? ( >=dev-python/sphinx-1.0.7[${PYTHON_USEDEP}] )
	test? ( ${PYTHON_DEPS//sqlite?/sqlite} )"

REQUIRED_USE="mysql? ( $(python_gen_useflags python2_7) )
		postgres? ( || ( $(python_gen_useflags 'python{2_7,3_2,3_3}') ) )"

S="${WORKDIR}/${MY_P}"

WEBAPP_MANUAL_SLOT="yes"

PATCHES=( "${FILESDIR}"/${PN}-1.5.4-objects.patch \
		"${FILESDIR}"/${PN}-1.5-py3tests.patch )

python_compile_all() {
	if use doc; then
		emake -C docs html
	fi
}

python_test() {
	# Tests have non-standard assumptions about PYTHONPATH,
	# and don't work with ${BUILD_DIR}/lib.
	# https://code.djangoproject.com/ticket/20514
	PYTHONPATH=. "${PYTHON}" tests/runtests.py --settings=test_sqlite -v1 \
		|| die "Tests fail with ${EPYTHON}"
}

src_install() {
	distutils-r1_src_install
	webapp_src_install
}

python_install_all() {
	newbashcomp extras/django_bash_completion ${PN}

	if use doc; then
		rm -fr docs/_build/html/_sources
		local HTML_DOCS=( docs/_build/html/. )
	fi

	insinto "${MY_HTDOCSDIR#${EPREFIX}}"
	doins -r django/contrib/admin/static/admin/.
	distutils-r1_python_install_all
}

pkg_postinst() {
	elog "A copy of the admin media is available to webapp-config for installation in a"
	elog "webroot, as well as the traditional location in python's site-packages dir"
	elog "for easy development."
	webapp_pkg_postinst
}
