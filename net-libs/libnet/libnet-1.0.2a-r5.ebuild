# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit autotools eutils toolchain-funcs

DESCRIPTION="library to provide an API for commonly used low-level network functions (mainly packet injection)"
HOMEPAGE="http://www.packetfactory.net/libnet/"
SRC_URI="http://www.packetfactory.net/libnet/dist/deprecated/${P}.tar.gz"

LICENSE="BSD BSD-2 HPND"
SLOT="1.0"
KEYWORDS="alpha amd64 arm hppa ppc ppc64 sparc x86"
IUSE=""

S=${WORKDIR}/Libnet-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.0.2a-gcc33-fix.patch \
		"${FILESDIR}"/${PN}-1.0.2a-slot.patch

	use arm && epatch "${FILESDIR}"/${PN}-1.0.2a-endian.patch

	cd "${S}"
	mv libnet-config.in libnet-${SLOT}-config.in || die "moving libnet-config"

	cd "${S}"/include
	ln -s libnet.h libnet-${SLOT}.h

	cd libnet
	for f in *.h ; do
		ln -s ${f} ${f/-/-${SLOT}-} || die "linking ${f}"
	done

	cd "${S}"/doc
	ln -s libnet.3 libnet-${SLOT}.3 || die "linking manpage"

	cd "${S}"
	sed -i configure.in -e '/CCOPTS=/d;/CFLAGS=/s|.*|:|' || die

	eautoconf

	tc-export AR RANLIB
}

src_install() {
	default
	doman "${D}"/usr/man/man3/libnet-1.0.3
	rm -r "${D}"/usr/man

	dodoc VERSION doc/{README,TODO*,CHANGELOG*}
	newdoc README README.1st
	docinto example ; dodoc example/libnet*
	docinto Ancillary ; dodoc doc/Ancillary/*
}

pkg_postinst(){
	elog "libnet ${SLOT} is deprecated !"
	elog "config script: libnet-${SLOT}-config"
	elog "manpage: libnet-${SLOT}"
	elog "library: libnet-${SLOT}.a"
	elog "include: libnet-${SLOT}.h"
}
