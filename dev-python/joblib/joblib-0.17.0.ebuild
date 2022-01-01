# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..9} )

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
# joblib is imported by setup.py so we need ${RDEPEND}
BDEPEND="
	${RDEPEND}
	test? (
		dev-python/threadpoolctl[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_prepare_all() {
	# unbundle
	rm -r joblib/externals || die
	sed -e "s:'joblib.externals[^']*',\?::g" -i setup.py || die
	find -name '*.py' -exec \
		sed -e 's:\(joblib\)\?\.externals\.::' \
			-e 's:from \.externals ::' \
			-i {} + || die

	# https://github.com/joblib/joblib/issues/1115
	sed -e 's:test_parallel_call_cached_function_defined_in_jupyter:_&:' \
		-i joblib/test/test_memory.py || die

	# tries to fetch from the internet
	rm examples/compressors_comparison.py \
		examples/parallel/distributed_backend_simple.py || die

	distutils-r1_python_prepare_all
}
