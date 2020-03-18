# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6 )
inherit distutils-r1

DESCRIPTION="Data migration in python"
HOMEPAGE="https://github.com/blaze/odo"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	>=dev-python/datashape-0.4.6[${PYTHON_USEDEP}]
	>=dev-python/dask-0.11.1[${PYTHON_USEDEP}]
	>=dev-python/multipledispatch-0.4.7[${PYTHON_USEDEP}]
	>=dev-python/numpy-1.7[${PYTHON_USEDEP}]
	>=dev-python/pandas-0.15.0[${PYTHON_USEDEP}]
	>=dev-python/toolz-0.7.3[${PYTHON_USEDEP}]
	dev-python/networkx[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	doc? ( dev-python/docutils )
"
# tests need very heavy deps (such as pyspark), skipping for now

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
