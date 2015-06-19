# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-arch/unrar/unrar-5.2.3.ebuild,v 1.1 2014/12/06 02:26:16 radhermit Exp $

EAPI=5
inherit eutils flag-o-matic multilib toolchain-funcs

MY_PN=${PN}src

DESCRIPTION="Uncompress rar files"
HOMEPAGE="http://www.rarlab.com/rar_add.htm"
SRC_URI="http://www.rarlab.com/rar/${MY_PN}-${PV}.tar.gz"

LICENSE="unRAR"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

RDEPEND="!<=app-arch/unrar-gpl-0.0.1_p20080417"

S=${WORKDIR}/unrar

src_prepare() {
	epatch "${FILESDIR}"/${PN}-5.0.2-build.patch
	epatch "${FILESDIR}"/${PN}-5.2.2-no-auto-clean.patch #528218
	local sed_args=( -e "/libunrar/s:.so:$(get_libname ${PV%.*.*}):" )
	if [[ ${CHOST} == *-darwin* ]] ; then
		sed_args+=( -e "s:-shared:-dynamiclib -install_name ${EPREFIX}/usr/$(get_libdir)/libunrar$(get_libname ${PV%.*.*}):" )
	else
		sed_args+=( -e "s:-shared:& -Wl,-soname -Wl,libunrar$(get_libname ${PV%.*.*}):" )
	fi
	sed -i "${sed_args[@]}" makefile
}

src_configure() {
	mkdir -p build-{lib,bin}
	printf 'VPATH = ..\ninclude ../makefile' > build-lib/Makefile || die
	cp build-{lib,bin}/Makefile || die
}

src_compile() {
	unrar_make() {
		emake CXX="$(tc-getCXX)" CXXFLAGS="${CXXFLAGS}" STRIP=true "$@"
	}

	unrar_make CXXFLAGS+=" -fPIC" -C build-lib lib
	ln -s libunrar$(get_libname ${PV%.*.*}) build-lib/libunrar$(get_libname)
	ln -s libunrar$(get_libname ${PV%.*.*}) build-lib/libunrar$(get_libname ${PV})

	unrar_make -C build-bin
}

src_install() {
	dobin build-bin/unrar
	dodoc readme.txt

	dolib.so build-lib/libunrar*

	insinto /usr/include/libunrar${PV%.*.*}
	doins *.hpp
	dosym libunrar${PV%.*.*} /usr/include/libunrar
}
