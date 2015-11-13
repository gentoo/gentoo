# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

SCM=""

if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/ultravideo/kvazaar"
fi

inherit multilib multilib-minimal toolchain-funcs ${SCM}

DESCRIPTION="An open-source HEVC encoder"
HOMEPAGE="http://ultravideo.cs.tut.fi/ https://github.com/ultravideo/kvazaar"

if [ "${PV#9999}" = "${PV}" ] ; then
	SRC_URI="https://github.com/ultravideo/kvazaar/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="cpu_flags_x86_avx2 static-libs"

DEPEND=""
RDEPEND="${DEPEND}"
S="${WORKDIR}/${P}/src"

ASM_DEP=">=dev-lang/yasm-1.2.0"
DEPEND="${DEPEND}
	abi_x86_32? ( ${ASM_DEP} )
	abi_x86_64? ( ${ASM_DEP} )"

src_prepare() {
	multilib_copy_sources
}

multilib_src_compile() {
	tc-export CC
	emake \
		ARCH="${CHOST%%-*}" \
		$(usex cpu_flags_x86_avx2 "" "KVZ_DISABLE_AVX2=true") \
		lib-shared \
		$(usex static-libs "lib-static" "") \
		$(multilib_is_native_abi && echo cli)
}

multilib_src_install() {
	emake \
		DESTDIR="${D}" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		install-pc install-lib \
		$(usex static-libs "install-static" "") \
		$(multilib_is_native_abi && echo install-prog)
}

multilib_src_install_all() {
	dodoc "${WORKDIR}/${P}/README.md" "${WORKDIR}/${P}/CREDITS" "${WORKDIR}/${P}/doc/"*.txt
}
