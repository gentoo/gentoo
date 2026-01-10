# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic ninja-utils toolchain-funcs

DESCRIPTION="A wine emulation dll for running x86 application on an arm64 host"
HOMEPAGE="https://fex-emu.com"

JEMALLOC_HASH="97d986993dc735a2022856e7e9fdfa1180e8527a"
CPP_OPTPARSE_HASH="9f94388a339fcbb0bc95c17768eb786c85988f6e"
ROBIN_MAP_HASH="d5683d9f1891e5b04e3e3b2192b5349dc8d814ea"
FMT_HASH="407c905e45ad75fc29bf0f9bb7c5c2fd3475976f"
XXHASH_HASH="e626a72bc2321cd320e953a0ccf1584cad60f363"
RANGE_V3_HASH="ca1388fb9da8e69314dda222dc7b139ca84e092f"

SRC_URI="
	https://github.com/FEX-Emu/jemalloc/archive/${JEMALLOC_HASH}.tar.gz -> jemalloc-${JEMALLOC_HASH}.tar.gz
	https://github.com/Sonicadvance1/cpp-optparse/archive/${CPP_OPTPARSE_HASH}.tar.gz -> cpp-optparse-${CPP_OPTPARSE_HASH}.tar.gz
	https://github.com/FEX-Emu/robin-map/archive/${ROBIN_MAP_HASH}.tar.gz -> robin-map-${ROBIN_MAP_HASH}.tar.gz
	https://github.com/Cyan4973/xxHash/archive/${XXHASH_HASH}.tar.gz -> xxhash-${XXHASH_HASH}.tar.gz
	https://github.com/fmtlib/fmt/archive/${FMT_HASH}.tar.gz -> fmt-${FMT_HASH}.tar.gz
	https://github.com/ericniebler/range-v3/archive/${RANGE_V3_HASH}.tar.gz -> range-v3-${RANGE_V3_HASH}.tar.gz
	https://github.com/FEX-Emu/FEX/archive/refs/tags/FEX-${PV}.tar.gz
"

S="${WORKDIR}/FEX-FEX-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-* ~arm64"
IUSE="+wow64 +arm64ec"
REQUIRED_USE="|| ( wow64 arm64ec )"

BDEPEND="
	arm64ec? ( dev-util/llvm-mingw64[arm64ec-pe(-)] )
	dev-build/cmake
	>=dev-util/llvm-mingw64-13.0.0
	llvm-core/clang
	llvm-core/llvm
"

pkg_setup() {
	HOSTS=(
		$(usev wow64 aarch64-w64-mingw32)
		$(usev arm64ec arm64ec-w64-mingw32)
	)
}

src_unpack() {
	default
	local -A deps=(
		jemalloc "jemalloc-${JEMALLOC_HASH}"
		robin-map "robin-map-${ROBIN_MAP_HASH}"
		xxhash "xxHash-${XXHASH_HASH}"
		fmt "fmt-${FMT_HASH}"
		range-v3 "range-v3-${RANGE_V3_HASH}"
	)
	for dep in "${!deps[@]}"; do
		rmdir "${S}/External/${dep}" || die
		mv "${WORKDIR}/${deps[${dep}]}" "${S}/External/${dep}"
	done
	rmdir "${S}/Source/Common/cpp-optparse" || die
	mv "${WORKDIR}/cpp-optparse-${CPP_OPTPARSE_HASH}" "${S}/Source/Common/cpp-optparse" || die
}

src_configure() {
	for CHOST in ${HOSTS[@]}; do
		(
			setup_env
			per_host_src_configure
		)
	done
}

setup_env() {
	PATH="${BROOT}/usr/lib/llvm-mingw64/bin:${PATH}"
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
}

per_host_src_configure() {
	mkdir "${WORKDIR}/${CHOST}-build" || die
	pushd "${WORKDIR}/${CHOST}-build" >/dev/null || die
	cmake -GNinja \
		-DCMAKE_C_COMPILER_WORKS=1 \
		-DCMAKE_CXX_COMPILER_WORKS=1 \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_TOOLCHAIN_FILE="${S}/Data/CMake/toolchain_mingw.cmake" \
		-DCMAKE_INSTALL_LIBDIR=/usr/lib/fex-xtajit \
		-DENABLE_LTO=False \
		-DMINGW_TRIPLE=${CHOST} \
		-DBUILD_TESTING=False \
		-DENABLE_JEMALLOC_GLIBC_ALLOC=False \
		-DCMAKE_INSTALL_PREFIX=/usr \
		-DENABLE_CCACHE=FALSE \
		-DBUILD_FEXCONFIG=FALSE \
		-DCMAKE_POLICY_VERSION_MINIMUM=3.5 \
		-DCMAKE_DISABLE_FIND_PACKAGE_fmt=true \
		-DCMAKE_DISABLE_FIND_PACKAGE_range-v3=true \
		"${S}" || die
	popd >/dev/null || die
}

src_compile() {
	for CHOST in ${HOSTS[@]}; do
		(
			setup_env
			per_host_src_compile
		)
	done
}

per_host_src_compile() {
	pushd "${WORKDIR}/${CHOST}-build" >/dev/null || die
	eninja
	popd >/dev/null || die
}

src_install() {
	for CHOST in ${HOSTS[@]}; do
		(
			setup_env
			per_host_src_install
		)
	done
}

per_host_src_install() {
	pushd "${WORKDIR}/${CHOST}-build" >/dev/null || die
	DESTDIR="${D}" eninja install
	popd >/dev/null || die
	rm -r "${ED}/usr/"{include,share} || die
}

pkg_postinst() {
	elog "If you had already created a wine prefix, run wineboot -u"
	elog "to install x86 emulation support, or update it's local copy"
	elog "of the relevant files."
}
