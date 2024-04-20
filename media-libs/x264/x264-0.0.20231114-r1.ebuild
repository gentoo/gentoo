# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Please bump with media-video/x264-encoder

inherit multilib-minimal toolchain-funcs flag-o-matic

DESCRIPTION="Free library for encoding X264/AVC streams"
HOMEPAGE="https://www.videolan.org/developers/x264.html"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://code.videolan.org/videolan/x264.git"
else
	X264_COMMIT="c196240409e4d7c01b47448d93b1f9683aaa7cf7"
	SRC_URI="https://code.videolan.org/videolan/x264/-/archive/${X264_COMMIT}/x264-${X264_COMMIT}.tar.bz2 -> ${P}.tar.bz2"
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
	S="${WORKDIR}/${PN}-${X264_COMMIT}"
fi

LICENSE="GPL-2"
SLOT="0/164" # SONAME
IUSE="cpu_flags_ppc_altivec +interlaced opencl static-libs +threads"

ASM_DEP=">=dev-lang/nasm-2.13"
DEPEND="
	abi_x86_32? ( ${ASM_DEP} )
	abi_x86_64? ( ${ASM_DEP} )
	opencl? ( dev-lang/perl )
"
RDEPEND="opencl? ( >=virtual/opencl-0-r3[${MULTILIB_USEDEP}] )"

DOCS=( AUTHORS doc/{ratecontrol,regression_test,standards,threads,vui}.txt )

multilib_src_configure() {
	tc-export CC

	if [[ ${ABI} == x86 || ${ABI} == amd64 ]]; then
		export AS="nasm"
	else
		export AS="${CC}"
	fi

	local asm_conf=""

	if \
		[[ ${ABI} == x86* ]] \
		|| [[ ${ABI} == "x32" ]] \
		|| [[ ${CHOST} == armv5* ]] \
		|| [[ ${ABI} == ppc* ]] && { use !cpu_flags_ppc_altivec ; } \
		|| use mips && { ! test-compile 'c' 'int main(void){__asm__("addvi.b $w0, $w1, 1");return 0;}' ; }
	then
		asm_conf=" --disable-asm"
	fi

	"${S}/configure" \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--disable-cli \
		--disable-avs \
		--disable-lavf \
		--disable-swscale \
		--disable-ffms \
		--disable-gpac \
		--enable-pic \
		--enable-shared \
		--host="${CHOST}" \
		--cross-prefix="${CHOST}-" \
		$(usex interlaced "" "--disable-interlaced") \
		$(usex opencl "" "--disable-opencl") \
		$(usex static-libs "--enable-static" "") \
		$(usex threads "" "--disable-thread") \
		${asm_conf} || die
}
