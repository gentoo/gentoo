# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/fmod/fmod-4.38.00.ebuild,v 1.5 2012/09/24 00:45:16 vapier Exp $

inherit versionator

MY_P=fmodapi$(delete_all_version_separators)linux

DESCRIPTION="music and sound effects library, and a sound processing system"
HOMEPAGE="http://www.fmod.org"
SRC_URI="x86? ( http://www.fmod.org/index.php/release/version/${MY_P}.tar.gz )
	amd64? ( http://www.fmod.org/index.php/release/version/${MY_P}64.tar.gz )"

LICENSE="BSD BSD-2 fmod"
SLOT="1"
KEYWORDS="amd64 x86"
IUSE="examples"

RESTRICT="strip test"

QA_FLAGS_IGNORED="opt/fmodex/tools/fsbanklib/.*"

QA_TEXTRELS="opt/fmodex/fmoddesignerapi/api/lib/*
opt/fmodex/api/lib/*"

src_compile() { :; }
src_install() {
	dodir /opt/fmodex

	local fbits=""
	use amd64 && fbits="64"

	local fsource="${WORKDIR}/${MY_P}${fbits}"

	cd "${fsource}"/api/lib

	cp -f libfmodex${fbits}-${PV}.so libfmodex.so.${PV} || die
	ln -sf libfmodex.so.${PV} libfmodex.so || die
	ln -sf libfmodex.so.${PV} libfmodex.so.4 || die

	cp -f libfmodexL${fbits}-${PV}.so libfmodexL.so.${PV} || die
	ln -sf libfmodexL.so.${PV} libfmodexL.so || die
	ln -sf libfmodexL.so.${PV} libfmodexL.so.4 || die

	cp -dpR "${fsource}"/* "${D}"/opt/fmodex || die

	dosym /opt/fmodex/api/inc /usr/include/fmodex || die

	use examples || rm -rf "${D}"/opt/fmodex/{,fmoddesignerapi}/examples

	insinto /usr/share/doc/${PF}/pdf
	doins "${fsource}"/documentation/*.pdf
	dodoc "${fsource}"/{documentation/*.txt,fmoddesignerapi/*.TXT}
	rm -rf "${D}"/opt/fmodex/{documentation,fmoddesignerapi/*.TXT}

	echo LDPATH="/opt/fmodex/api/lib" > "${T}"/65fmodex
	doenvd "${T}"/65fmodex
}
