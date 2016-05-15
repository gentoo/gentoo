# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} )

inherit distutils-r1

DESCRIPTION="Statistical and novel interactive HTML plots for Python"
HOMEPAGE="http://bokeh.pydata.org/ http://github.com/bokeh/bokeh http://pypi.python.org/pypi/bokeh"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples test"

# A doc build requires napoleon sphinx extension which will be included in sphinx release 1.3
# Therefore refraining from adding the doc build for now
RDEPEND="
	dev-python/abstract_rendering[${PYTHON_USEDEP}]
	>=dev-python/colorama-0.2.7[${PYTHON_USEDEP}]
	>=dev-python/flask-0.10.1[${PYTHON_USEDEP}]
	>=dev-python/jinja-2.7[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.7.1[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.11[${PYTHON_USEDEP}]
	>=dev-python/python-dateutil-2.1[${PYTHON_USEDEP}]
	>=dev-python/pyyaml-3.10[${PYTHON_USEDEP}]
	>=dev-python/pyzmq-14.3.1[${PYTHON_USEDEP}]
	>=dev-python/redis-py-2.7.6[${PYTHON_USEDEP}]
	>=dev-python/requests-1.2.3[${PYTHON_USEDEP}]
	>=dev-python/six-1.5.2[${PYTHON_USEDEP}]
	dev-python/websocket-client[${PYTHON_USEDEP}]
	>=dev-python/werkzeug-0.9.1[${PYTHON_USEDEP}]
	>=www-servers/tornado-4.0.1[${PYTHON_USEDEP}]
	"
# testing server: needs websocket not in portage yet
# websocket is in pypi for the adding
# hdf5 backend: needs array management not in portage yet
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '>=dev-python/mock-1.0.1[${PYTHON_USEDEP}]' python2_7)
	)
	"
python_test() {
	cd "${BUILD_DIR}"/lib || die
	# exclude server tests for now
	nosetests -v \
		-e multiuser_auth_test \
		-e usermodel_test \
		|| die
}

python_install_all() {
	use examples && local EXAMPLES=( examples/. )

	distutils-r1_python_install_all
}
