# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 pypi

DESCRIPTION="Fast serialization and validation library, with builtin support for many formats"
HOMEPAGE="
	https://jcristharif.com/msgspec/
	https://github.com/jcrist/msgspec
	https://pypi.org/project/msgspec/
"
# No tests in sdist
SRC_URI="https://github.com/jcrist/msgspec/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

BDEPEND="
	dev-python/cython[${PYTHON_USEDEP}]
	dev-python/versioneer[${PYTHON_USEDEP}]
	test? (
		dev-python/attrs[${PYTHON_USEDEP}]
		dev-python/msgpack[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
	)
"

EPYTEST_IGNORE=(
	# Lint tests
	tests/test_cpylint.py
	tests/test_mypy.py
	tests/test_pyright.py
)

EPYTEST_PLUGINS=()

distutils_enable_tests pytest

src_prepare() {
	# remove outdated bundled versioneer
	rm versioneer.py || die
	distutils-r1_src_prepare
}

python_test() {
	rm -rf msgspec || die
	epytest
}
