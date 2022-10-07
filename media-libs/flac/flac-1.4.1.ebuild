# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="Free lossless audio encoder and decoder"
HOMEPAGE="https://xiph.org/flac/"
SRC_URI="https://downloads.xiph.org/releases/${PN}/${P}.tar.xz"

LICENSE="BSD FDL-1.2 GPL-2 LGPL-2.1"
# <libFLAC SONAME>-<libFLAC++ SONAME>
SLOT="0/10-12"
KEYWORDS="~alpha ~amd64 arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE="+cxx debug ogg cpu_flags_ppc_altivec cpu_flags_ppc_vsx cpu_flags_x86_avx2 cpu_flags_x86_avx cpu_flags_x86_sse2 static-libs"

# AVX configure switch is for both AVX & AVX2
REQUIRED_USE="
	cpu_flags_x86_avx2? ( cpu_flags_x86_avx )
"

RDEPEND="ogg? ( media-libs/libogg[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}"
BDEPEND="
	app-arch/xz-utils
	sys-devel/gettext
	virtual/pkgconfig
	abi_x86_32? ( dev-lang/nasm )"

multilib_src_configure() {
	local myeconfargs=(
		--disable-doxygen-docs
		--disable-examples
		--disable-xmms-plugin
		$([[ ${CHOST} == *-darwin* ]] && echo "--disable-asm-optimizations")
		$(use_enable cpu_flags_ppc_altivec altivec)
		$(use_enable cpu_flags_ppc_vsx vsx)
		$(use_enable cpu_flags_x86_avx avx)
		# SSE option is actually for SSE2, bug #677274
		$(use_enable cpu_flags_x86_sse2 sse)
		$(use_enable cxx cpplibs)
		$(use_enable debug)
		$(use_enable ogg)
		$(use_enable static-libs static)

		# cross-compile fix (bug #521446)
		# no effect if ogg support is disabled
		--with-ogg
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_test() {
	if [[ ${UID} != 0 ]]; then
		emake -j1 check
	else
		ewarn "Tests will fail if ran as root, skipping."
	fi
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -type f -name '*.la' -delete || die
}
