# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit cmake python-any-r1

DESCRIPTION="C Markdown parser. Fast, SAX-like interface, CommonMark Compliant."
HOMEPAGE="https://github.com/mity/md4c"
# TODO(NRK):
# - useflag for static lib (?)

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mity/md4c.git"
else
	SRC_URI="https://github.com/mity/md4c/archive/refs/tags/release-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/md4c-release-${PV}"
	KEYWORDS="amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="MIT test? ( CC-BY-SA-4.0 )"
SLOT="0"
IUSE="+md2html test"
REQUIRED_USE="test? ( md2html )"
RESTRICT="!test? ( test )"

BDEPEND="test? ( ${PYTHON_DEPS} )"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	mycmakeargs=(
		-DBUILD_SHARED_LIBS=ON
		-DBUILD_MD2HTML_EXECUTABLE=$(usex md2html)
	)

	cmake_src_configure
}

src_test() {
	pushd "${BUILD_DIR}" || die
	# Uses python internally
	"${S}"/scripts/run-tests.sh || die
	popd
}
