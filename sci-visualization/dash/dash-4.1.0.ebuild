# Copyright 2021-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..14} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1
JUPV=2.18.2

DESCRIPTION="Python framework for building ML & data science web apps"
HOMEPAGE="https://github.com/plotly/dash"
SRC_URI="https://github.com/plotly/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz
	https://dev.gentoo.org/~tupone/distfiles/${PN}-jupyterlab-${JUPV}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="compress diskcache"

# Test need some packages not yet in the tree
# flask_talisman
# percy
# ...
RESTRICT="test"

RDEPEND="
	dev-python/flask[${PYTHON_USEDEP}]
	dev-python/importlib-metadata[${PYTHON_USEDEP}]
	dev-python/nest-asyncio[${PYTHON_USEDEP}]
	dev-python/plotly[${PYTHON_USEDEP}]
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/retrying[${PYTHON_USEDEP}]
	dev-python/typing-extensions[${PYTHON_USEDEP}]
	dev-python/werkzeug[${PYTHON_USEDEP}]
	compress? ( dev-python/flask-compress[${PYTHON_USEDEP}] )
	diskcache? (
		dev-python/diskcache[${PYTHON_USEDEP}]
		dev-python/multiprocess[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
	)
	"
DEPEND="${RDEPEND}"

src_prepare() {
	mkdir dash/labextension/dist || die
	# These are the step to build dash-jupyterlab:
	# cd @plotly/dash-jupyterlab
	# jlpm install
	# jlpm build:pack
	cp "${DISTDIR}"/${PN}-jupyterlab-${JUPV}.tgz \
		dash/labextension/dist/${PN}-jupyterlab.tgz \
		|| die
	distutils-r1_src_prepare
}

python_install_all() {
	distutils-r1_python_install_all
	mv "${ED}"/usr/etc "${ED}"/etc || die
}
