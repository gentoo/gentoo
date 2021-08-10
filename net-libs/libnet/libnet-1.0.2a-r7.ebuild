# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="library providing an API for commonly used low-level network functions"
HOMEPAGE="http://www.packetfactory.net/libnet/"
SRC_URI="http://www.packetfactory.net/libnet/dist/deprecated/${P}.tar.gz"
S="${WORKDIR}"/Libnet-${PV}

LICENSE="BSD BSD-2 HPND"
SLOT="1.0"
KEYWORDS="~alpha amd64 arm ~hppa ppc ppc64 sparc x86"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.2a-gcc33-fix.patch
	"${FILESDIR}"/${PN}-1.0.2a-slot.patch
	"${FILESDIR}"/${PN}-1.0.2a-endian.patch
	"${FILESDIR}"/${PN}-1.0.2a-_SOURCE.patch
	"${FILESDIR}"/${PN}-1.0.2a-funroll.patch
	"${FILESDIR}"/${PN}-1.0.2a-test.patch

)

src_prepare() {
	default

	cd "${S}" || die
	mv libnet-config.in libnet-${SLOT}-config.in || die "moving libnet-config"

	cd "${S}"/include || die
	ln -s libnet.h libnet-${SLOT}.h || die

	cd libnet || die
	for f in *.h ; do
		ln -s ${f} ${f/-/-${SLOT}-} || die
	done

	cd "${S}"/doc || die
	ln -s libnet.3 libnet-${SLOT}.3 || die

	cd "${S}" || die

	eautoreconf
	tc-export AR RANLIB
}

src_test() {
	emake -C test
}

src_install() {
	default
	doman "${ED}"/usr/man/man3/libnet-1.0.3
	rm -r "${ED}"/usr/man || die

	dodoc VERSION doc/{README,TODO*,CHANGELOG*}
	newdoc README README.1st

	docinto example
	dodoc example/libnet*

	docinto Ancillary
	dodoc doc/Ancillary/*
}
