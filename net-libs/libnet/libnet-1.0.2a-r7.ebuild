# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools toolchain-funcs

DESCRIPTION="library providing an API for commonly used low-level network functions"
HOMEPAGE="http://www.packetfactory.net/libnet/"
SRC_URI="http://www.packetfactory.net/libnet/dist/deprecated/${P}.tar.gz"

LICENSE="BSD BSD-2 HPND"
SLOT="1.0"
KEYWORDS="~alpha amd64 arm hppa ppc ppc64 sparc x86"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.2a-gcc33-fix.patch
	"${FILESDIR}"/${PN}-1.0.2a-slot.patch
	"${FILESDIR}"/${PN}-1.0.2a-endian.patch
	"${FILESDIR}"/${PN}-1.0.2a-_SOURCE.patch
	"${FILESDIR}"/${PN}-1.0.2a-funroll.patch
	"${FILESDIR}"/${PN}-1.0.2a-test.patch

)
S=${WORKDIR}/Libnet-${PV}

src_prepare() {
	default

	cd "${S}"
	mv libnet-config.in libnet-${SLOT}-config.in || die "moving libnet-config"

	cd "${S}"/include
	ln -s libnet.h libnet-${SLOT}.h

	cd libnet
	for f in *.h ; do
		ln -s ${f} ${f/-/-${SLOT}-} || die
	done

	cd "${S}"/doc
	ln -s libnet.3 libnet-${SLOT}.3 || die

	cd "${S}"

	eautoconf

	tc-export AR RANLIB
}

src_test() {
	emake -C test
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
