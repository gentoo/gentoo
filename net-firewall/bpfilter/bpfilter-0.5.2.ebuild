# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_1{1..3} )
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
RESTRICT+=" test"

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
	"${FILESDIR}/bpfilter-0.5.0-no-coverage.patch"
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

src_prepare() {
	sed -e '/get_version_from_git/ d' -i CMakeLists.txt || die
	cmake_src_prepare
}

src_configure() {
	local CMAKE_BUILD_TYPE=release
	local -a mycmakeargs=(
		-DNO_CHECKS=ON
		-DNO_BENCHMARKS=ON
		-DDEFAULT_PROJECT_VERSION="${PV}"
		-DNO_DOCS=$(usex doc 'OFF' 'ON')
		-DNO_TESTS=$(usex test 'OFF' 'ON')
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile
	use doc && cmake_build doc
}

src_test() {
	cmake_src_test
	cmake_build e2e || die "tests failed"
}

src_install() {
	cmake_src_install
	use doc && dodoc -r "${BUILD_DIR}/doc/"{ht,x}ml
}
