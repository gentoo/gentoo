# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Browser-based graphing library for Python"
HOMEPAGE="https://plotly.com/python/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

# TODO: package plotly-orca and kaleido
RESTRICT="test"

RDEPEND="
	>=dev-python/tenacity-6.2.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.15.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		$(python_gen_cond_dep '
			dev-python/backports-tempfile[${PYTHON_USEDEP}]
		' 3.8)
		dev-python/inflect[${PYTHON_USEDEP}]
		dev-python/ipykernel[${PYTHON_USEDEP}]
		dev-python/ipython[${PYTHON_USEDEP}]
		dev-python/jupyter[${PYTHON_USEDEP}]
		dev-python/jupyterlab[${PYTHON_USEDEP}]
		dev-python/matplotlib[${PYTHON_USEDEP}]
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/pandas[${PYTHON_USEDEP}]
		dev-python/pillow[${PYTHON_USEDEP}]
		dev-python/psutil[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
		dev-python/statsmodels[${PYTHON_USEDEP}]
		dev-python/xarray[${PYTHON_USEDEP}]
		sci-libs/pyshp[${PYTHON_USEDEP}]
		sci-libs/scikit-image[${PYTHON_USEDEP}]
		sci-libs/shapely[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_install_all() {
	distutils-r1_python_install_all

	mkdir -p "${ED}"/etc/ || die
	mv "${ED}"/usr/etc/jupyter "${ED}"/etc/ || die
	rmdir "${ED}"/usr/etc || die
}
