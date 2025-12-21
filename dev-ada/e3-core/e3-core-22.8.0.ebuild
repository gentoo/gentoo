# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..13} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 toolchain-funcs

DESCRIPTION="Ease the development of portable automated build systems"
HOMEPAGE="https://www.adacore.com/"
SRC_URI="https://github.com/AdaCore/${PN}/archive/refs/tags/v${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND="
	dev-python/colorama[${PYTHON_USEDEP}]
	dev-python/coverage[${PYTHON_USEDEP}]
	dev-python/distro[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/requests-toolbelt[${PYTHON_USEDEP}]
	dev-python/resolvelib[${PYTHON_USEDEP}]
	dev-python/stevedore[${PYTHON_USEDEP}]
	dev-python/tomlkit[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	!app-editors/e3"
DEPEND="${RDEPEND}"
BDEPEND="test? (
	dev-python/httpretty[${PYTHON_USEDEP}]
	dev-python/mock[${PYTHON_USEDEP}]
	dev-python/ptyprocess[${PYTHON_USEDEP}]
	dev-python/pytest-socket[${PYTHON_USEDEP}]
	dev-python/requests-mock[${PYTHON_USEDEP}]
	dev-python/requests-cache[${PYTHON_USEDEP}]
	dev-vcs/subversion
)"

PATCHES=(
	"${FILESDIR}"/${PN}-22.6.0-pkg_resource.patch
)

distutils_enable_tests pytest
distutils_enable_sphinx docs/source dev-python/sphinx-rtd-theme dev-python/sphinx-autoapi

python_compile() {
	distutils-r1_python_compile
	find "${BUILD_DIR}" -name '*.pth' -delete || die
}

src_compile() {
	local PLATFORM
	if use amd64; then
		PLATFORM=x86_64
	elif use x86; then
		PLATFORM=x86
	elif use arm64; then
		PLATFORM=aarch64
	else
		die "Not a recognized platform"
	fi
	PLATFORM+="-linux"
	rm src/e3/os/data/rlimit* || die
	$(tc-getCC) ${CFLAGS} -o src/e3/os/data/rlimit-${PLATFORM} \
		tools/rlimit/rlimit.c ${LDFLAGS}
	distutils-r1_src_compile
}

src_test() {
	local EPYTEST_IGNORE=(
		tests/tests_e3/python/main_test.py
	)
	local EPYTEST_DESELECT=(
		tests/tests_e3/cve/cve_test.py::test_nvd_cve_search
		tests/tests_e3/anod/spec_test.py::test_spec_check_dll_closure[arguments0-expected0]
	)
	distutils-r1_src_test
}
