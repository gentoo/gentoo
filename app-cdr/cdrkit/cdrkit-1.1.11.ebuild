# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3
inherit cmake-utils

DESCRIPTION="A set of tools for CD/DVD reading and recording, including cdrecord"
HOMEPAGE="http://cdrkit.org"
SRC_URI="mirror://debian/pool/main/c/${PN}/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 s390 sparc x86 ~x86-fbsd"
IUSE="debug hfs unicode"

RDEPEND="app-arch/bzip2
	!app-cdr/cdrtools
	sys-apps/file
	sys-libs/zlib
	unicode? ( virtual/libiconv )
	kernel_linux? ( sys-libs/libcap )"
DEPEND="${RDEPEND}
	hfs? ( sys-apps/file )"

src_prepare() {
	echo '.so wodim.1' > ${T}/cdrecord.1
	echo '.so genisoimage.1' > ${T}/mkisofs.1
	echo '.so icedax.1' > ${T}/cdda2wav.1
	echo '.so readom.1' > ${T}/readcd.1
}

src_install() {
	cmake-utils_src_install

	dosym wodim /usr/bin/cdrecord || die
	dosym genisoimage /usr/bin/mkisofs || die
	dosym icedax /usr/bin/cdda2wav || die
	dosym readom /usr/bin/readcd || die

	dodoc ABOUT Changelog FAQ FORK TODO doc/{PORTABILITY,WHY}

	local x
	for x in genisoimage plattforms wodim icedax; do
		docinto ${x}
		dodoc doc/${x}/*
	done

	insinto /etc
	newins wodim/wodim.dfl wodim.conf || die
	newins netscsid/netscsid.dfl netscsid.conf || die

	insinto /usr/include/scsilib
	doins include/*.h || die
	insinto /usr/include/scsilib/usal
	doins include/usal/*.h || die
	dosym usal /usr/include/scsilib/scg || die

	doman "${T}"/*.1
}
