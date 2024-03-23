# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs

DESCRIPTION="A Modern Linker"
HOMEPAGE="https://github.com/rui314/mold"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://github.com/rui314/mold.git"
	inherit git-r3
else
	SRC_URI="https://github.com/rui314/mold/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~loong ~riscv ~sparc ~x86"
fi

# mold (MIT)
#  - xxhash (BSD-2)
LICENSE="MIT BSD-2"
SLOT="0"

RDEPEND="
	app-arch/zstd:=
	>=dev-cpp/tbb-2021.7.0-r1:=
	dev-libs/blake3:=
	sys-libs/zlib
	!kernel_Darwin? (
		>=dev-libs/mimalloc-2:=
	)
"
DEPEND="${RDEPEND}"

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
	cmake_src_prepare

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

src_configure() {
	local mycmakeargs=(
		-DCMAKE_DISABLE_PRECOMPILE_HEADERS=ON
		-DMOLD_ENABLE_QEMU_TESTS=OFF
		-DMOLD_LTO=OFF # Should be up to the user to decide this with CXXFLAGS.
		-DMOLD_USE_MIMALLOC=$(usex !kernel_Darwin)
		-DMOLD_USE_SYSTEM_MIMALLOC=ON
		-DMOLD_USE_SYSTEM_TBB=ON
	)
	cmake_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/${PN}

	# https://bugs.gentoo.org/872773
	insinto /usr/$(get_libdir)/mold
	doins "${BUILD_DIR}"/${PN}-wrapper.so

	dodoc docs/{design,execstack}.md
	doman docs/${PN}.1

	dosym ${PN} /usr/bin/ld.${PN}
	dosym ${PN} /usr/bin/ld64.${PN}
	dosym -r /usr/bin/${PN} /usr/libexec/${PN}/ld
}

src_test() {
	export TEST_CC="$(tc-getCC)" \
		   TEST_GCC="$(tc-getCC)" \
		   TEST_CXX="$(tc-getCXX)" \
		   TEST_GXX="$(tc-getCXX)"
	cmake_src_test
}
