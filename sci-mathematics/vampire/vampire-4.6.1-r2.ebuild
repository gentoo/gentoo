# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic cmake

DESCRIPTION="The Vampire Prover, theorem prover for first-order logic"
HOMEPAGE="https://vprover.github.io"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vprover/${PN}.git"
	EGIT_SUBMODULES=()
else
	SRC_URI="https://github.com/vprover/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0/${PV}"
IUSE="debug +z3"
# debug mode needs to be enabled for tests
# https://github.com/vprover/vampire/blob/8197e1d2d86a0b276b5fcb6c02d8122f66b7277e/CMakeLists.txt#L38
RESTRICT="!debug? ( test )"

RDEPEND="
	z3? (
		dev-libs/gmp:=
		>=sci-mathematics/z3-4.11.2:=
	)
"
DEPEND="${RDEPEND}"

src_configure() {
	# -Werror=strict-aliasing warnings, bug #863269
	filter-lto
	append-flags -fno-strict-aliasing

	local CMAKE_BUILD_TYPE
	if use debug; then
		CMAKE_BUILD_TYPE=Debug
	else
		CMAKE_BUILD_TYPE=Release
	fi

	local mycmakeargs=( -DZ3_DIR=$(usex z3 "/usr/$(get_libdir)/cmake/z3/" "") )
	cmake_src_configure
}

src_install() {
	local bin_name=$(find "${BUILD_DIR}"/bin/ -type f -name "${PN}*")
	dobin "${bin_name}"
	dosym $(basename "${bin_name}") /usr/bin/${PN}

	einstalldocs
}
