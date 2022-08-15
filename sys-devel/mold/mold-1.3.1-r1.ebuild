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
	KEYWORDS="~amd64 ~riscv"
fi

LICENSE="AGPL-3"
SLOT="0"

RDEPEND=">=dev-cpp/tbb-2021.4.0:=
	sys-libs/zlib
	!kernel_Darwin? (
		>=dev-libs/mimalloc-2:=
		dev-libs/openssl:=
	)"
# As of 1.1, xxhash is now a header-only dep, but it's now bundled :(
# TODO: restore SYSTEM_XXHASH upstream?
DEPEND="${RDEPEND}"

PATCHES=(
	# Bug #841575
	"${FILESDIR}"/${PN}-1.2.1-install-nopython.patch
	"${FILESDIR}"/${PN}-1.3.0-openssl-pkgconfig.patch
	# Bug #861488
	"${FILESDIR}"/${PN}-1.3.1-fix-riscv-set32.patch
)

pkg_pretend() {
	# Requires a c++20 compiler, see #831473
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
	rm test/elf/{{dead,compress}-debug-sections,compressed-debug-info}.sh || die

	# Heavy tests, need qemu
	rm test/elf/gdb-index-{compress-output,dwarf{2,3,4,5}}.sh || die
	rm test/elf/lto-{archive,dso,gcc,llvm,version-script}.sh || die

	# Sandbox sadness
	rm test/elf/run.sh || die
	sed -i 's|`pwd`/mold-wrapper.so|"& ${LD_PRELOAD}"|' \
		test/elf/mold-wrapper{,2}.sh || die

	# static-pie tests require glibc built with static-pie support
	if ! has_version -d 'sys-libs/glibc[static-pie(+)]'; then
		rm test/elf/{,ifunc-}static-pie.sh || die
	fi
}

src_compile() {
	tc-export CC CXX

	emake \
		CFLAGS="${CFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		SYSTEM_TBB=1 \
		SYSTEM_MIMALLOC=1 \
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
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		STRIP="true" \
		install
}
