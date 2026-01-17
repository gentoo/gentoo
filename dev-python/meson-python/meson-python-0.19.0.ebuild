# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1

DESCRIPTION="Meson PEP 517 Python build backend"
HOMEPAGE="
	https://pypi.org/project/meson-python/
	https://github.com/mesonbuild/meson-python/
"
SRC_URI="
	https://github.com/mesonbuild/meson-python/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos"

RDEPEND="
	>=dev-python/pyproject-metadata-0.7.1[${PYTHON_USEDEP}]
	>=dev-build/meson-0.63.0
	!kernel_Darwin? ( dev-util/patchelf )
"
BDEPEND="
	${RDEPEND}
	test? (
		>=dev-python/cython-0.29.34
		>=dev-python/packaging-23.1[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

EPYTEST_PLUGINS=( pytest-mock )
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# Strip unnecessary Python-level dependency on meson, it is used
	# as an external executable anyway.
	sed -i -e '/meson >=/d' pyproject.toml || die
}

src_test() {
	# required by tests/test_sdist.py::test_reproducible
	git config --global user.email "test@example.com" || die
	git config --global user.name "The Test Suite" || die
	git init -q || die
	git add -A || die
	git commit -m init -q || die

	distutils-r1_src_test
}

python_test() {
	unset NINJA

	local EPYTEST_DESELECT=()
	if ! has_version "dev-build/meson[${PYTHON_USEDEP}]"; then
		EPYTEST_DESELECT+=(
			tests/test_wheel.py::test_vendored_meson
		)
	fi

	epytest
}
