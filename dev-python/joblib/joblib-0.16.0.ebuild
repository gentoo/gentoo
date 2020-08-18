# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..8} )

inherit distutils-r1

DESCRIPTION="Tools to provide lightweight pipelining in Python"
HOMEPAGE="https://joblib.readthedocs.io/en/latest/
	https://github.com/joblib/joblib"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

RDEPEND="
	dev-python/cloudpickle[${PYTHON_USEDEP}]
	dev-python/loky[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/threadpoolctl[${PYTHON_USEDEP}]
	)
"

distutils_enable_sphinx doc \
	'dev-python/numpy' \
	'dev-python/matplotlib' \
	'dev-python/pillow' \
	'dev-python/sphinx-gallery' \
	'dev-python/numpydoc' \
	'dev-python/pandas' \
	'dev-python/lz4' \
	'dev-python/distributed'

distutils_enable_tests pytest

python_prepare_all() {
	# unbundle
	rm -r joblib/externals || die
	sed -e "s:'joblib.externals[^']*',\?::g" -i setup.py || die
	find -name '*.py' -exec \
		sed -e 's:\(joblib\)\?\.externals\.::' \
			-e 's:from \.externals ::' \
			-i {} + || die

	sed -e "s:'_static/joblib_logo_examples.png':'doc/_static/joblib_logo_examples.png':" \
		-i doc/conf.py || die

	# tries to fetch from the internet
	rm examples/compressors_comparison.py \
		examples/parallel/distributed_backend_simple.py || die

	distutils-r1_python_prepare_all
}
