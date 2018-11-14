# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4,3_5} )

inherit distutils-r1

DESCRIPTION="Data migration in python"
HOMEPAGE="https://github.com/ContinuumIO/odo"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

DEPEND="app-arch/unzip
	doc? ( dev-python/docutils )"
RDEPEND=">=dev-python/datashape-0.4.4[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.7[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.15.0[${PYTHON_USEDEP}]
	dev-python/toolz[${PYTHON_USEDEP}]
	>=dev-python/multipledispatch-0.4.7[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
	"

python_prepare_all() {
	sed -e '/.. toctree::/d' -i docs/source/index.rst|| die
	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		pushd docs/source > /dev/null
		mkdir ../build || die
		local i;
		for i in ./*
		do
	        	rst2html.py $i > ../build/${i/rst/html} || die
		done
		popd > /dev/null
	fi
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/. )
	distutils-r1_python_install_all
}
