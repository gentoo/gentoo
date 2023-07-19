# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=standalone
PYTHON_COMPAT=( python3_{10..12} pypy3 )

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
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos"

RDEPEND="
	>=dev-python/pyproject-metadata-0.7.1[${PYTHON_USEDEP}]
	>=dev-util/meson-0.63.0[${PYTHON_USEDEP}]
	!kernel_Darwin? ( dev-util/patchelf )
	$(python_gen_cond_dep '
		>=dev-python/tomli-1.0.0[${PYTHON_USEDEP}]
	' 3.9 3.10)
"
BDEPEND="
	>=dev-python/cython-0.29.34[${PYTHON_USEDEP}]
	test? (
		dev-python/pytest-mock[${PYTHON_USEDEP}]
		$(python_gen_cond_dep '
			>=dev-python/typing-extensions-3.7.4[${PYTHON_USEDEP}]
		' 3.9)
	)
"

PATCHES=( "${FILESDIR}"/meson-python-0.13.2_Mach-O_bundle.patch )

distutils_enable_tests pytest

python_test() {
	local EPYTEST_DESELECT=(
		# requires network access
		tests/test_pep518.py::test_pep518
		# requires git repo
		# https://github.com/mesonbuild/meson-python/issues/397
		tests/test_project.py::test_user_args
	)
	unset NINJA

	if [[ ${EPYTHON} == pypy3 ]]; then
		EPYTEST_DESELECT+=(
			# broken venv usage that copies pypy3 executable, making it
			# unable to find lib_pypy
			tests/test_editable.py::test_editable_install
			tests/test_editable.py::test_editble_reentrant
			tests/test_examples.py::test_spam
			tests/test_wheel.py::test_local_lib
		)
	fi

	epytest

	rm -rf docs/examples/spam/build/ || die # remove artifacts
}
