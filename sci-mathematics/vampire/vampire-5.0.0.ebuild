# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_IN_SOURCE_BUILD="true"

inherit flag-o-matic cmake

DESCRIPTION="The Vampire Prover, theorem prover for first-order logic"
HOMEPAGE="https://vprover.github.io/
	https://github.com/vprover/vampire/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/vprover/${PN}"
else
	SRC_URI="https://github.com/vprover/${PN}/releases/download/v${PV}/${PN}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0/${PV}"
IUSE="test +z3"
RESTRICT="!test? ( test )"

RDEPEND="
	z3? (
		dev-libs/gmp:=
		>=sci-mathematics/z3-4.11.2:=
	)
"
DEPEND="
	${RDEPEND}
"

src_configure() {
	# -Werror=strict-aliasing warnings, bug #863269
	filter-lto
	append-flags -fno-strict-aliasing

	# Only compiles in the Debug build.
	local CMAKE_BUILD_TYPE="Debug"

	local -a mycmakeargs=(
		-DZ3_DIR=$(usex z3 "/usr/$(get_libdir)/cmake/z3/" "")
	)
	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use test ; then
		eninja vtest
	fi
}

src_install() {
	dobin "${PN}"
	einstalldocs
}
