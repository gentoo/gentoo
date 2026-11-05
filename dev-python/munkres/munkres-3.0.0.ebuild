# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
PYPI_VERIFY_REPO=https://github.com/iameishit/Paldita-munkres
PYTHON_COMPAT=( python3_{12..15} )

inherit meson distutils-r1 pypi

DESCRIPTION="Module implementing munkres algorithm for the Assignment Problem"
HOMEPAGE="
	https://github.com/iameishit/Paldita-munkres/
	https://pypi.org/project/munkres/
"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="+native-extensions"

BDEPEND="
	test? (
		dev-python/numpy[${PYTHON_USEDEP}]
		dev-python/scipy[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=( hypothesis )
EPYTEST_XDIST=1
distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	# don't ask
	mv pyproject.meson.toml pyproject.toml || die
}

src_configure() {
	DISTUTILS_ARGS=(
		$(meson_feature native-extensions native)
	)
}

python_test() {
	local EPYTEST_DESELECT=(
		# junk tests that require dotfiles from the git repo
		tests/integration/test_examples_and_benchmarks.py::test_release_verifier_reports_no_problems
		tests/test_repo_hygiene.py

		# upstream build system tests
		tests/test_meson_build.py

		# super slow
		tests/hard/test_kernel_hard.py::test_no_memory_growth_over_many_calls
		# too slow to pass
		tests/hard/test_system_hard.py::test_pathological_runtimes_stay_bounded
	)

	epytest
}
