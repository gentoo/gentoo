# Copyright 2019-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1 virtualx

DESCRIPTION="Convert matplotlib figures into TikZ/PGFPlots"
HOMEPAGE="https://github.com/nschloe/tikzplotlib"
SRC_URI="https://github.com/nschloe/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	app-text/texlive[extra]
	$( python_gen_cond_dep \
		'dev-python/importlib_metadata[${PYTHON_USEDEP}]' python3_7 )
	dev-python/matplotlib[latex,${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
"

BDEPEND="
	dev-python/wheel[${PYTHON_USEDEP}]
	test? (
		dev-python/exdown[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
)"

distutils_enable_tests pytest
distutils_enable_sphinx doc dev-python/mock

python_prepare_all() {
	# setup.py was removed in commit f04323cfa575caf8a25a9236f55fe6baf1a33b20
	# for some reason, DISTUTULS_USE_SETUPTOOLS="pyproject.toml" is not working
	# it complains about file not found, setup.cfg does exist

	cat > setup.py <<EOF || die
from setuptools import setup

if __name__ == "__main__":
	setup()
EOF

	# Lots of TeX errors
	rm test/test_patches.py || die
	rm test/test_context.py || die

	distutils-r1_python_prepare_all
}

python_test() {
	local -x MPLBACKEND=Agg
	virtx pytest -vv
}
