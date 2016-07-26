# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

SCM=""

if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/ultravideo/kvazaar"
fi

inherit multilib autotools multilib-minimal toolchain-funcs ${SCM}

DESCRIPTION="An open-source HEVC encoder"
HOMEPAGE="http://ultravideo.cs.tut.fi/ https://github.com/ultravideo/kvazaar"

if [ "${PV#9999}" = "${PV}" ] ; then
	SRC_URI="https://github.com/ultravideo/kvazaar/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc"
fi

LICENSE="LGPL-2.1"
# subslot = libkvazaar major
SLOT="0/3"
IUSE="cpu_flags_x86_avx2 static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

ASM_DEP=">=dev-lang/yasm-1.2.0"
DEPEND="${DEPEND}
	abi_x86_32? ( ${ASM_DEP} )
	abi_x86_64? ( ${ASM_DEP} )"

src_prepare() {
	eautoreconf
}

multilib_src_compile() {
	ECONF_SOURCE="${S}" \
		econf \
			--docdir "/usr/share/doc/${PF}" \
			$(use_enable static-libs static) \
			$(use_enable cpu_flags_x86_avx2 asm)
}

multilib_src_install_all() {
	find "${ED}" -name '*.la' -delete
}
