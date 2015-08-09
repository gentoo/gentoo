# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs multilib-minimal

DESCRIPTION="A flexible, cross-platform scripting library"
HOMEPAGE="http://www.angelcode.com/angelscript/"
SRC_URI="http://www.angelcode.com/angelscript/sdk/files/angelscript_${PV}.zip"

LICENSE="ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"

DEPEND="app-arch/unzip"

S=${WORKDIR}/sdk
S2=${WORKDIR}/sdk_static

pkg_setup() {
	tc-export CXX AR RANLIB
}

src_prepare() {
	if use static-libs ; then
		cp -pR "${WORKDIR}"/sdk "${S2}"/ || die
	fi
	epatch "${FILESDIR}"/${P}-execstack.patch
	multilib_copy_sources
}

multilib_src_compile() {
	einfo "Shared build"
	emake -C ${PN}/projects/gnuc SHARED=1 VERSION=${PV}

	if use static-libs ; then
		einfo "Static build"
		emake -C ${PN}/projects/gnuc
	fi
}

multilib_src_install() {
	doheader ${PN}/include/angelscript.h
	dolib.so ${PN}/lib/libangelscript-${PV}.so
	dosym libangelscript-${PV}.so /usr/$(get_libdir)/libangelscript.so

	if use static-libs ; then
		 dolib.a ${PN}/lib/libangelscript.a
	fi
}

multilib_src_install_all() {
	use doc && dohtml -r "${WORKDIR}"/sdk/docs/*
}
