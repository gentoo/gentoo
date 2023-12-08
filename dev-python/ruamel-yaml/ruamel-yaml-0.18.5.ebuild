# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{10..12} )

inherit distutils-r1

MY_P="${P/-/.}"
DESCRIPTION="YAML parser/emitter that supports roundtrip comment preservation"
HOMEPAGE="
	https://pypi.org/project/ruamel.yaml/
	https://sourceforge.net/projects/ruamel-yaml/
"
# PyPI tarballs do not include tests
SRC_URI="mirror://sourceforge/ruamel-dl-tagged-releases/${MY_P}.tar.xz"
S="${WORKDIR}"/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ~ia64 ~loong ~m68k ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="
	dev-python/ruamel-yaml-clib[${PYTHON_USEDEP}]
	!dev-python/namespace-ruamel
"
BDEPEND="
	test? (
		dev-python/ruamel-std-pathlib[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

python_test() {
	local EPYTEST_DESELECT=()
	[[ ${EPYTHON} == pypy3 ]] && EPYTEST_DESELECT+=(
		_test/test_deprecation.py::test_collections_deprecation
	)
	local EPYTEST_IGNORE=(
		# Old PyYAML tests from lib/ require special set-up and are
		# invoked indirectly via test_z_olddata, tell pytest itself
		# to leave the subdir alone.
		_test/lib/
	)

	# this is needed to keep the tests working while
	# dev-python/namespace-ruamel is still installed
	distutils_write_namespace ruamel
	epytest
}
