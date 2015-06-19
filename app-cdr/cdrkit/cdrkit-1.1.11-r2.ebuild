# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-cdr/cdrkit/cdrkit-1.1.11-r2.ebuild,v 1.9 2015/04/18 20:38:52 pacho Exp $

EAPI=5
inherit cmake-utils eutils

DESCRIPTION="A set of tools for CD/DVD reading and recording, including cdrecord"
HOMEPAGE="http://cdrkit.org"
SRC_URI="mirror://debian/pool/main/c/${PN}/${PN}_${PV}.orig.tar.gz
	http://dev.gentoo.org/~ssuominen/${P}-libcdio-paranoia.tar.xz"

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~mips ppc ppc64 sparc x86 ~x86-fbsd ~arm-linux ~x86-linux"
IUSE="debug hfs unicode"

RDEPEND="app-arch/bzip2
	!app-cdr/cdrtools
	dev-libs/libcdio-paranoia
	sys-apps/file
	sys-libs/zlib
	unicode? ( virtual/libiconv )
	kernel_linux? ( sys-libs/libcap )"
DEPEND="${RDEPEND}
	hfs? ( sys-apps/file )"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-cmakewarn.patch \
		"${WORKDIR}"/patches/${P}-paranoiacdda.patch \
		"${WORKDIR}"/patches/${P}-paranoiacdio.patch

	echo '.so wodim.1' > ${T}/cdrecord.1
	echo '.so genisoimage.1' > ${T}/mkisofs.1
	echo '.so icedax.1' > ${T}/cdda2wav.1
	echo '.so readom.1' > ${T}/readcd.1
}

src_install() {
	cmake-utils_src_install

	dosym wodim /usr/bin/cdrecord
	dosym genisoimage /usr/bin/mkisofs
	dosym icedax /usr/bin/cdda2wav
	dosym readom /usr/bin/readcd

	dodoc ABOUT Changelog FAQ FORK TODO doc/{PORTABILITY,WHY}

	local x
	for x in genisoimage plattforms wodim icedax; do
		docinto ${x}
		dodoc doc/${x}/*
	done

	insinto /etc
	newins wodim/wodim.dfl wodim.conf
	newins netscsid/netscsid.dfl netscsid.conf

	insinto /usr/include/scsilib
	doins include/*.h
	insinto /usr/include/scsilib/usal
	doins include/usal/*.h
	dosym usal /usr/include/scsilib/scg

	doman "${T}"/*.1
}
