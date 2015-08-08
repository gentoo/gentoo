# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 readme.gentoo

DESCRIPTION="Statistical and interactive HTML plots for Python"
HOMEPAGE="http://bokeh.pydata.org/"
SRC_URI="https://github.com/ContinuumIO/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="examples test"

# A doc build requires napoleon sphinx extension which will be included in sphinx release 1.3
# Therefore refraining from adding the doc build for now
RDEPEND="
	>=dev-python/colorama-0.2.7[${PYTHON_USEDEP}]
	>=dev-python/click-3.3[${PYTHON_USEDEP}]
	>=dev-python/flask-0.10.1[${PYTHON_USEDEP}]
	>=dev-python/greenlet-0.4.1[${PYTHON_USEDEP}]
	>=dev-python/itsdangerous-0.21[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.7[${PYTHON_USEDEP}]
	>=dev-python/markdown-2.3.1[${PYTHON_USEDEP}]
	>=dev-python/markupsafe-0.18[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.7.1[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.11[${PYTHON_USEDEP}]
	>=dev-python/pygments-1.6[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.1[${PYTHON_USEDEP}]
	>=dev-python/pystache-0.5.3[${PYTHON_USEDEP}]
	>=dev-python/pytz-2013b[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-14.3.1[${PYTHON_USEDEP}]
	>=dev-python/redis-py-2.7.6[${PYTHON_USEDEP}]
	>=dev-python/requests-1.2.3[${PYTHON_USEDEP}]
	>=dev-python/six-1.5.2[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-0.9.1[${PYTHON_USEDEP}]
	>=net-libs/nodejs-0.8.28[npm]
	>=www-client/phantomjs-1.9.8
	>=www-servers/tornado-4.0.1[${PYTHON_USEDEP}]
	$(python_gen_cond_dep '>=dev-python/gevent-1.0[${PYTHON_USEDEP}]' python2_7)
	$(python_gen_cond_dep '>=dev-python/gevent-websocket-0.9.2[${PYTHON_USEDEP}]' python2_7)
	"
# testing server: needs websocket not in portage yet
# websocket is in pypi for the adding
# hdf5 backend: needs array management not in portage yet
DEPEND="
	test? (
		${RDEPEND}
		>=dev-python/nose-1.3.0[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]' python2_7)
		>=dev-python/colorama-0.2.7[${PYTHON_USEDEP}] )
	"
DOCS=( CHANGELOG QUICKSTART.md README.md )

PATCHES=( "${FILESDIR}"/${P}-setup.patch )

DISTUTILS_NO_PARALLEL_BUILD=1

python_prepare_all() {
	DOC_CONTENTS="websockets work only with python2_7"

	sed -i -e "s/jsbuild = get_user_jsargs()/jsbuild = False/g" setup.py || die
	cd bokehjs || die
	npm install ||die
	cd .. || die
	esetup.py --build_js sdist

	distutils-r1_python_prepare_all
}

python_install_all() {
	readme.gentoo_create_doc

	use examples && local EXAMPLES=( examples/. )

	distutils-r1_python_install_all
}

python_test() {
	cd "${BUILD_DIR}"/lib || die
	# exclude server tests for now
	nosetests -v \
		-e multiuser_auth_test \
		-e usermodel_test \
		|| die
}
