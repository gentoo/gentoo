# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-multilib

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://aomedia.googlesource.com/aom"
else
	if [[ ${PV} == *pre* ]]; then
		SRC_URI="mirror://gentoo/${P}.tar.xz"
		S="${WORKDIR}/${PN}"
	else
		# SRC_URI="https://aomedia.googlesource.com/aom/+archive/v${PV}.tar.gz -> ${P}.tar.gz"
		SRC_URI="mirror://gentoo/${P}.tar.gz"
		S="${WORKDIR}"
	fi
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ia64 ppc ppc64 ~sparc x86"
fi

DESCRIPTION="Alliance for Open Media AV1 Codec SDK"
HOMEPAGE="https://aomedia.org"

LICENSE="BSD-2"
SLOT="0/0"
IUSE="doc examples"
IUSE="${IUSE} cpu_flags_x86_mmx cpu_flags_x86_sse cpu_flags_x86_sse2 cpu_flags_x86_sse3 cpu_flags_x86_ssse3 cpu_flags_x86_sse4_1 cpu_flags_x86_avx cpu_flags_x86_avx2"
IUSE="${IUSE} cpu_flags_arm_neon"

RDEPEND=""
DEPEND="abi_x86_32? ( dev-lang/yasm )
	abi_x86_64? ( dev-lang/yasm )
	abi_x86_x32? ( dev-lang/yasm )
	x86-fbsd? ( dev-lang/yasm )
	amd64-fbsd? ( dev-lang/yasm )
	doc? ( app-doc/doxygen )
"

REQUIRED_USE="
	cpu_flags_x86_sse2? ( cpu_flags_x86_mmx )
	cpu_flags_x86_ssse3? ( cpu_flags_x86_sse2 )
"

PATCHES=(
	"${FILESDIR}/libdirpc2.patch"
	"${FILESDIR}/pthread_lib2.patch"
	"${FILESDIR}/${P}-version.patch"
	"${FILESDIR}/${P}-armv7l.patch"
	"${FILESDIR}/${P}-update-vsx-ppc.patch"
)

# the PATENTS file is required to be distributed with this package bug #682214
DOCS=( PATENTS )

src_prepare() {
	sed -e 's/lib"/lib${LIB_SUFFIX}"/' -i CMakeLists.txt || die
	cmake-utils_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DENABLE_DOCS=$(multilib_native_usex doc ON OFF)
		-DENABLE_EXAMPLES=$(multilib_native_usex examples ON OFF)
		-DENABLE_NASM=OFF
		-DENABLE_TOOLS=ON
		-DENABLE_WERROR=OFF

		-DENABLE_NEON=$(usex cpu_flags_arm_neon ON OFF)
		-DENABLE_NEON_ASM=$(usex cpu_flags_arm_neon ON OFF)
		# ENABLE_DSPR2 / ENABLE_MSA for mips
		-DENABLE_MMX=$(usex cpu_flags_x86_mmx ON OFF)
		-DENABLE_SSE=$(usex cpu_flags_x86_sse ON OFF)
		-DENABLE_SSE2=$(usex cpu_flags_x86_sse2 ON OFF)
		-DENABLE_SSE3=$(usex cpu_flags_x86_sse3 ON OFF)
		-DENABLE_SSSE3=$(usex cpu_flags_x86_ssse3 ON OFF)
		-DENABLE_SSE4_1=$(usex cpu_flags_x86_sse4_1 ON OFF)
		-DENABLE_AVX=$(usex cpu_flags_x86_avx ON OFF)
		-DENABLE_AVX2=$(usex cpu_flags_x86_avx2 ON OFF)

		-DBUILD_SHARED_LIBS=ON
	)
	cmake-utils_src_configure
	rm aom.pc # ensure it is rebuilt with proper libdir
}

multilib_src_install() {
	cmake-utils_src_install
	if multilib_is_native_abi && use doc ; then
		docinto html
		dodoc docs/html/*
	fi
}
