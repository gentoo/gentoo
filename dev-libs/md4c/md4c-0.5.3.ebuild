# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit cmake python-any-r1

DESCRIPTION="C Markdown parser. Fast, SAX-like interface, CommonMark Compliant"
HOMEPAGE="https://github.com/mity/md4c"
SRC_URI="
	https://github.com/mity/md4c/archive/refs/tags/release-${PV}.tar.gz
		-> ${P}.tar.gz
"
S=${WORKDIR}/md4c-release-${PV}

LICENSE="MIT test? ( CC-BY-SA-4.0 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~ppc ~ppc64 ~riscv ~x86"

IUSE="+md2html test"
REQUIRED_USE="test? ( md2html )"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( ${PYTHON_DEPS} )
"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_MD2HTML_EXECUTABLE=$(usex md2html)
	)

	cmake_src_configure
}

src_test() {
	cd "${BUILD_DIR}" || die
	"${EPYTHON}" "${S}"/scripts/run-tests.py || die
}
