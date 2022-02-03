# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( pypy3 python3_{8..10} )
inherit distutils-r1

MY_P="${P/-/.}"
DESCRIPTION="YAML parser/emitter that supports roundtrip comment preservation"
HOMEPAGE="
	https://pypi.org/project/ruamel.yaml/
	https://sourceforge.net/p/ruamel-yaml/"
# PyPI tarballs do not include tests
SRC_URI="mirror://sourceforge/ruamel-dl-tagged-releases/${MY_P}.tar.xz"
S="${WORKDIR}"/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"

RDEPEND="
	dev-python/namespace-ruamel[${PYTHON_USEDEP}]
	dev-python/ruamel-yaml-clib[${PYTHON_USEDEP}]"
BDEPEND="
	test? (
		dev-python/ruamel-std-pathlib[${PYTHON_USEDEP}]
	)"

distutils_enable_tests pytest

# Old PyYAML tests from lib/ require special set-up and are invoked indirectly
# via test_z_olddata, tell pytest itself to leave the subdir alone.
python_test() {
	[[ ${EPYTHON} == pypy3 ]] && local EPYTEST_DESELECT=(
		_test/test_deprecation.py::test_collections_deprecation
	)
	local EPYTEST_IGNORE=(
		_test/lib/
	)
	epytest
}

python_install() {
	distutils-r1_python_install --single-version-externally-managed
	find "${ED}" -name '*.pth' -delete || die
}
