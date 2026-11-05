# Copyright 2025-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_1{3..5} )
inherit python-any-r1 cmake

DESCRIPTION="BPF-based packet filtering framework"
HOMEPAGE="
	https://bpfilter.io/
	https://github.com/facebook/bpfilter
"
SRC_URI="https://github.com/facebook/bpfilter/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0/0"
KEYWORDS="~amd64"
IUSE="doc test"

RESTRICT="!test? ( test )"

# tests need root access
#RESTRICT+=" test"

DEPEND="
	dev-libs/libbpf:=
	dev-libs/libnl:3=
	test? (
		dev-util/cmocka
	)
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/bison
	sys-devel/flex
	doc? (
		app-text/doxygen
		$(python_gen_any_dep '
			dev-python/sphinx[${PYTHON_USEDEP}]
			dev-python/linuxdoc[${PYTHON_USEDEP}]
			dev-python/breathe[${PYTHON_USEDEP}]
			dev-python/furo[${PYTHON_USEDEP}]
		')
	)
	test? (
		$(python_gen_any_dep '
			net-analyzer/scapy[${PYTHON_USEDEP}]
		')
	)
"

PATCHES=(
	"${FILESDIR}/bpfilter-0.8.0-docs.patch"
)

DOCS=(
	CONTRIBUTING.md
	README.md
)

pkg_setup() {
	(use test || use doc) && python-any-r1_pkg_setup
}

python_check_deps() {
	local -a atoms
	if use doc; then
		python_has_version \
			"dev-python/sphinx[${PYTHON_USEDEP}]" \
			"dev-python/breathe[${PYTHON_USEDEP}]" \
			"dev-python/linuxdoc[${PYTHON_USEDEP}]" \
			"dev-python/furo[${PYTHON_USEDEP}]" \
		|| return
	fi
	if use test; then
		python_has_version \
			"net-analyzer/scapy[${PYTHON_USEDEP}]" \
		|| return
	fi
}

src_configure() {
	local CMAKE_BUILD_TYPE=release
	local -a mycmakeargs=(
		-DWITH_DOCS=$(usex doc 'ON' 'OFF')
		-DWITH_TESTS=$(usex test 'ON' 'OFF')
		$(usex test '-DWITH_TESTS_BENCHMARKS=OFF' '')
		$(usex test '-DWITH_TESTS_FUZZING=OFF' '')
		$(usex test '-DWITH_TESTS_E2E=OFF' '')
		$(usex test '-DWITH_TESTS_CHECKS=OFF' '')
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_src_compile doc
}

src_install() {
	cmake_src_install
	use doc && dodoc -r "${BUILD_DIR}/doc/"{ht,x}ml
}
