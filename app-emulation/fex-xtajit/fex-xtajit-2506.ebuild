# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic ninja-utils toolchain-funcs

DESCRIPTION="A wine emulation dll for running x86 application on an arm64 host"
HOMEPAGE="https://fex-emu.com"

JEMALLOC_HASH="02ca52b5fefc0ccd0d2c4eaa1d17989cdd641927"
CPP_OPTPARSE_HASH="9f94388a339fcbb0bc95c17768eb786c85988f6e"
ROBIN_MAP_HASH="d5683d9f1891e5b04e3e3b2192b5349dc8d814ea"
FMT_HASH="123913715afeb8a437e6388b4473fcc4753e1c9a"
XXHASH_HASH="bbb27a5efb85b92a0486cf361a8635715a53f6ba"

SRC_URI="
	https://github.com/FEX-Emu/jemalloc/archive/${JEMALLOC_HASH}.tar.gz -> jemalloc-${JEMALLOC_HASH}.tar.gz
	https://github.com/Sonicadvance1/cpp-optparse/archive/${CPP_OPTPARSE_HASH}.tar.gz -> cpp-optparse-${CPP_OPTPARSE_HASH}.tar.gz
	https://github.com/FEX-Emu/robin-map/archive/${ROBIN_MAP_HASH}.tar.gz -> robin-map-${ROBIN_MAP_HASH}.tar.gz
	https://github.com/Cyan4973/xxHash/archive/${XXHASH_HASH}.tar.gz -> xxhash-${XXHASH_HASH}.tar.gz
	https://github.com/fmtlib/fmt/archive/${FMT_HASH}.tar.gz -> fmt-${FMT_HASH}.tar.gz
	https://github.com/FEX-Emu/FEX/archive/refs/tags/FEX-${PV}.tar.gz
"

S="${WORKDIR}/FEX-FEX-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~arm64"
BDEPEND="
	dev-build/cmake
	dev-util/llvm-mingw64
	llvm-core/clang
	llvm-core/llvm
"

src_prepare() {
	has_version '<dev-util/llvm-mingw64-13.0.0' && eapply "${FILESDIR}/${P}-constness.patch"
	default
}

src_unpack() {
	default
	local -A deps=(
		jemalloc "jemalloc-${JEMALLOC_HASH}"
		robin-map "robin-map-${ROBIN_MAP_HASH}"
		xxhash "xxHash-${XXHASH_HASH}"
		fmt "fmt-${FMT_HASH}"
	)
	for dep in "${!deps[@]}"; do
		rmdir "${S}/External/${dep}" || die
		mv "${WORKDIR}/${deps[${dep}]}" "${S}/External/${dep}"
	done
	rmdir "${S}/Source/Common/cpp-optparse" || die
	mv "${WORKDIR}/cpp-optparse-${CPP_OPTPARSE_HASH}" "${S}/Source/Common/cpp-optparse" || die
}

src_configure() {
	PATH="${BROOT}/usr/lib/llvm-mingw64/bin:${PATH}"
	CHOST=aarch64-w64-mingw32
	CC=${CHOST}-clang
	CXX=${CHOST}-clang++
	LD=${CHOST}-clang
	AR=llvm-ar
	NM=llvm-nm
	RANLIB=llvm-ranlib
	STRIP=llvm-strip
	RC=${CHOST}-windres
	KERNEL=Winnt
	tc-export CC CXX LD AR NM OBJDUMP RANLIB PKG_CONFIG

	strip-flags
	filter-lto
	filter-flags '-fuse-ld=*'
	strip-unsupported-flags

	mkdir "${WORKDIR}/build" || die
	pushd "${WORKDIR}/build" >/dev/null || die
	cmake -GNinja \
		-DCMAKE_C_COMPILER_WORKS=1 \
		-DCMAKE_CXX_COMPILER_WORKS=1 \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_TOOLCHAIN_FILE="${S}/toolchain_mingw.cmake" \
		-DCMAKE_INSTALL_LIBDIR=/usr/lib/fex-xtajit \
		-DENABLE_LTO=False \
		-DMINGW_TRIPLE=aarch64-w64-mingw32 \
		-DBUILD_TESTS=False \
		-DENABLE_JEMALLOC_GLIBC_ALLOC=False \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DENABLE_CCACHE=FALSE \
		-DBUILD_FEXCONFIG=FALSE \
		-DMINGW_BUILD=1 \
		-DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
		-DCMAKE_DISABLE_FIND_PACKAGE_fmt=true \
		"${S}" || die
	popd >/dev/null || die
}

src_compile() {
	pushd "${WORKDIR}/build" >/dev/null || die
	eninja
	popd >/dev/null || die
}

src_install() {
	pushd "${WORKDIR}/build" >/dev/null || die
	DESTDIR="${D}" eninja install
	popd >/dev/null || die
	rm -r "${ED}/usr/"{include,share} || die
}

pkg_postinst() {
	elog "If you had already created a wine prefix, run wineboot -u"
	elog "to install x86 emulation support, or update it's local copy"
	elog "of the relevant files."
}
