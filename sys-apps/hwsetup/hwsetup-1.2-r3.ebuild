# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils toolchain-funcs flag-o-matic

MY_PV=${PV}-7
DESCRIPTION="Hardware setup program from Knoppix - used only on LiveCD"
HOMEPAGE="http://www.knopper.net/"
SRC_URI="http://debian-knoppix.alioth.debian.org/sources/${PN}_${MY_PV}.tar.gz"
#http://developer.linuxtag.net/knoppix/sources/${PN}_${MY_PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 -mips ppc ppc64 sparc x86"
IUSE="zlib"

COMMON_DEPEND="
	sys-apps/pciutils[zlib?]
	zlib? ( sys-libs/zlib )
"
DEPEND="
	${COMMON_DEPEND}
	sys-libs/libkudzu
"
RDEPEND="
	${COMMON_DEPEND}
	sys-apps/hwdata-gentoo
"

pkg_setup() {
	ewarn "This package is designed for use on the LiveCD only and will do "
	ewarn "unspeakably horrible and unexpected things on a normal system."
	ewarn "YOU HAVE BEEN WARNED!!!"
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${MY_PV}-dyn_blacklist.patch \
		"${FILESDIR}"/${PV}-3-fastprobe.patch \
		"${FILESDIR}"/${MY_PV}-gentoo.patch \
		"${FILESDIR}"/${PV}-strip.patch \
		"${FILESDIR}"/${MY_PV}-openchrome.patch
}

src_configure() {
	if use zlib ; then
		sed -i \
			-e '/^LIBS=/s,-lpci,-lz -lpci,g' \
			Makefile
	fi
}

src_compile() {
	emake LDFLAGS="${LDFLAGS}" OPT="${CFLAGS}" CC="$(tc-getCC)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr MANDIR=/usr/share/man
	dosbin ${PN}
	keepdir /etc/sysconfig
}

pkg_postinst() {
	ewarn "This package is intended for use on the Gentoo release media.  If"
	ewarn "you are not building a CD, remove this package.  It will not work"
	ewarn "properly on a running system, as Gentoo does not use any of the"
	ewarn "Knoppix-style detection except for CD builds."
}
