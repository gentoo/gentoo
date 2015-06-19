# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/xanim-export/xanim-export-2.80.1-r5.ebuild,v 1.6 2012/12/29 14:33:04 ago Exp $

inherit flag-o-matic eutils toolchain-funcs

_XA_CYUV_sparc=xa1.0_cyuv_sparcELF.o
_XA_CVID_sparc=xa2.0_cvid_sparcELF.o
_XA_IV32_sparc=xa2.0_iv32_sparcELF.o
_XA_EXT_sparc=.Z

_XA_CYUV_x86=xa1.0_cyuv_linuxELFg21.o
_XA_CVID_x86=xa2.0_cvid_linuxELFg21.o
_XA_IV32_x86=xa2.1_iv32_linuxELFg21.o
_XA_EXT_x86=.gz

_XA_CYUV_ppc=xa1.0_cyuv_linuxPPC.o
_XA_CVID_ppc=xa2.0_cvid_linuxPPC.o
_XA_IV32_ppc=xa2.0_iv32_linuxPPC.o
_XA_EXT_ppc=.Z

MY_P="xanim_exporting_edition"

# This might leave _XA_EXT empty and that's fine, just indicates no
# particular support for a given arch
eval _XA_EXT=\${_XA_EXT_${ARCH}}
eval _XA_CVID=\${_XA_CVID_${ARCH}}
eval _XA_CYUV=\${_XA_CYUV_${ARCH}}
eval _XA_IV32=\${_XA_IV32_${ARCH}}

# Not much we could do here, the modules are predownloaded and
# xanim-export compiles against them
QA_EXECSTACK_x86="usr/bin/xanim-export
	    usr/lib/xanim/mods-export/${_XA_CVID}
	    usr/lib/xanim/mods-export/${_XA_CYUV}
	    usr/lib/xanim/mods-export/${_XA_IV32}
	    usr/lib/xanim/mods-export/${_XA_CVID/g21/}
	    usr/lib/xanim/mods-export/${_XA_CYUV/g21/}
	    usr/lib/xanim/mods-export/xa2.0_iv32_linuxELF.o"

DESCRIPTION="XAnim with Quicktime and RAW Audio export functions"
HOMEPAGE="http://heroin.linuxave.net/toys.html"
SRC_URI="http://heroine.linuxave.net/${MY_P}.tar.gz
	sparc? (
		ftp://xanim.va.pubnix.com/modules/${_XA_CYUV_sparc}${_XA_EXT_sparc}
		ftp://xanim.va.pubnix.com/modules/${_XA_CVID_sparc}${_XA_EXT_sparc}
		ftp://xanim.va.pubnix.com/modules/${_XA_IV32_sparc}${_XA_EXT_sparc}
	)
	ppc? (
		ftp://xanim.va.pubnix.com/modules/${_XA_CYUV_ppc}${_XA_EXT_ppc}
		ftp://xanim.va.pubnix.com/modules/${_XA_CVID_ppc}${_XA_EXT_ppc}
		ftp://xanim.va.pubnix.com/modules/${_XA_IV32_ppc}${_XA_EXT_ppc}
	)
	x86? (
		ftp://xanim.va.pubnix.com/modules/${_XA_CYUV_x86}${_XA_EXT_x86}
		ftp://xanim.va.pubnix.com/modules/${_XA_CVID_x86}${_XA_EXT_x86}
		ftp://xanim.va.pubnix.com/modules/${_XA_IV32_x86}${_XA_EXT_x86}
	)"

LICENSE="XAnim"
SLOT="0"
KEYWORDS="ppc sparc x86"
IUSE=""

RDEPEND="virtual/jpeg
	media-libs/libpng
	x11-libs/libXext
	x11-libs/libXt
	media-libs/libquicktime"
DEPEND="${RDEPEND}
	app-arch/ncompress
	x11-proto/xextproto
	x11-proto/xproto
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_unpack() {
	unpack ${MY_P}.tar.gz

	if [[ -n ${_XA_EXT} ]]; then
		cd "${S}"/mods || die
		unpack ${_XA_CVID}${_XA_EXT}
		unpack ${_XA_CYUV}${_XA_EXT}
		unpack ${_XA_IV32}${_XA_EXT}
	fi

	cd "${S}"
	rm -f xanim
	epatch "${FILESDIR}"/${PV}-gentoo.patch \
		"${FILESDIR}"/${PV}-implicit_funcs.patch
}

src_compile() {
	tc-export CC
	make \
		XA_IV32_LIB=mods/${_XA_CYUV} \
		XA_CVID_LIB=mods/${_XA_CVID} \
		XA_CYUV_LIB=mods/${_XA_IV32} \
		OPTIMIZE="${CFLAGS}" \
		|| die "main make failed"
}

src_install() {
	newbin xanim xanim-export
	insinto /usr/lib/xanim/mods-export
	doins mods/*
	dodoc README*
	dodoc docs/README.* docs/*.readme docs/*.doc
}
