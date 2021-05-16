# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="LUIse"

DESCRIPTION="Programming interface for the Wallbraun LCD-USB-Interface"
HOMEPAGE="https://web.archive.org/web/20140102061822/http://wallbraun-electronics.de/"
SRC_URI="https://dev.gentoo.org/~conikost/files/${MY_PN}_${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="examples"

RDEPEND="virtual/libusb:0"

S="${WORKDIR}/${MY_PN}_${PV}"

QA_PREBUILT="
	usr/lib/libluise.so.${PV}
	usr/lib64/libluise.so.${PV}
"

src_install() {
	insinto /usr/$(get_libdir)
	newins $(usex amd64 '64' '32')bit/libluise$(usex amd64 '_64' '').so.${PV} libluise.so.${PV}
	dosym ../../usr/$(get_libdir)/libluise.so.${PV} /usr/$(get_libdir)/libluise.so.${SLOT}
	dosym ../../usr/$(get_libdir)/libluise.so.${PV} /usr/$(get_libdir)/libluise.so

	insinto /usr/include
	doins $(usex amd64 '64' '32')bit/luise.h

	dodoc doc/*
	use examples && dodoc -r samples/luise-test
}
