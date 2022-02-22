# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A Modern Linker"
HOMEPAGE="https://github.com/rui314/mold"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/rui314/mold.git"
	inherit git-r3
else
	SRC_URI="https://github.com/rui314/mold/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="AGPL-3"
SLOT="0"

# Try again after 1.0 (nearly there, but path-related issues)
# https://github.com/rui314/mold/issues/137
RESTRICT="test"

RDEPEND=">=dev-cpp/tbb-2021.4.0:=
	dev-libs/xxhash:=
	sys-libs/zlib
	!kernel_Darwin? (
		>=dev-libs/mimalloc-2:=
		dev-libs/openssl:=
	)"
DEPEND="${RDEPEND}"

pkg_pretend() {
	# Requires a c++20 compiler, see #831437
	if [[ ${MERGE_TYPE} != binary ]]; then
		if tc-is-gcc && [[ $(gcc-major-version) -lt 10 ]]; then
			die "${PN} needs at least gcc 10"
		elif tc-is-clang && [[ $(clang-major-version) -lt 12 ]]; then
			die "${PN} needs at least clang 12"
		fi
	fi
}

src_prepare() {
	default

	# Needs unpackaged dwarfdump
	rm test/elf/{compress-debug-sections,compressed-debug-info}.sh || die
}

src_compile() {
	tc-export CC CXX

	emake \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		SYSTEM_TBB=1 \
		SYSTEM_MIMALLOC=1 \
		SYSTEM_XXHASH=1 \
		STRIP="true" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
}

src_test() {
	emake \
		SYSTEM_TBB=1 \
		SYSTEM_MIMALLOC=1 \
		check
}

src_install() {
	emake \
		SYSTEM_TBB=1 \
		SYSTEM_MIMALLOC=1 \
		SYSTEM_XXHASH=1 \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		STRIP="true" \
		install
}
