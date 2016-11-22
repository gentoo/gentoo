# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
MY_PV="${PV/0_beta/b}"
DESCRIPTION="RAR compressor/uncompressor"
HOMEPAGE="http://www.rarsoft.com/"
URI_x86="http://www.rarlab.com/rar/rarlinux-${MY_PV}.tar.gz"
URI_amd64="http://www.rarlab.com/rar/rarlinux-x64-${MY_PV}.tar.gz"
URI_w64="http://www.rarlab.com/rar/winrar-x64-${MY_PV//.}.exe"
SRC_URI="x86? ( ${URI_x86} )
	amd64? ( ${URI_amd64} )
	all_sfx? (
		${URI_x86}
		${URI_amd64}
		${URI_w64}
	)"

LICENSE="RAR BSD BSD-2"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="all_sfx static"
RESTRICT="mirror bindist"

DEPEND="all_sfx? ( app-arch/unrar )"
RDEPEND="sys-libs/glibc"

S=${WORKDIR}/${PN}

QA_FLAGS_IGNORED="opt/rar/default.sfx
	opt/rar/default-elf32.sfx
	opt/rar/default-elf64.sfx
	opt/rar/default-win32.sfx
	opt/rar/default-win64.sfx
	opt/rar/WinCon.SFX
	opt/rar/WinCon64.SFX
	opt/rar/Zip.SFX
	opt/rar/Zip64.SFX
	opt/rar/unrar
	opt/rar/rar"
QA_PRESTRIPPED=${QA_FLAGS_IGNORED}

src_unpack() {
	use x86 && unpack ${URI_x86##*/}
	use amd64 && unpack ${URI_amd64##*/}
	rm -f "${S}"/license.txt
	if use all_sfx ; then
		mkdir sfx
		cd sfx
		unpack ${URI_x86##*/}
		mv rar/default.sfx default-elf32.sfx || die
		unpack ${URI_amd64##*/}
		mv rar/default.sfx default-elf64.sfx || die
		ln -s "${DISTDIR}"/${URI_w64##*/} w64.rar
		unpack ./w64.rar
		mv Default.SFX default-win32.sfx || die
		mv Default64.SFX default-win64.sfx || die
	fi
}

src_compile() { :; }

src_install() {
	exeinto /opt/rar
	doexe rar unrar || die
	use static && { newexe rar_static rar || die ; }

	dodir /opt/bin
	dosym ../rar/rar /opt/bin/rar || die
	dosym ../rar/unrar /opt/bin/unrar || die

	insinto /opt/rar
	if use all_sfx ; then
		doins "${WORKDIR}"/sfx/*.{sfx,SFX} || die
	else
		doins default.sfx || die
	fi
	doins rarfiles.lst || die
	dodoc *.txt
}
