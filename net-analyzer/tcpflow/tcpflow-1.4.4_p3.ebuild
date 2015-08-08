# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils

DESCRIPTION="A tool for monitoring, capturing and storing TCP connections flows"
HOMEPAGE="https://github.com/simsong/tcpflow http://packages.qa.debian.org/t/tcpflow.html"
SRC_URI="
	mirror://debian/pool/main/t/${PN}/${PN}_${PV/_p*}+repack1.orig.tar.gz
	mirror://debian/pool/main/t/${PN}/${PN}_${PV/_p*}+repack1-${PV/*_p}.debian.tar.xz
"

LICENSE="GPL-3"
KEYWORDS="amd64 ~arm ppc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos"
SLOT="0"
IUSE="cairo +pcap test"

RDEPEND="
	app-forensics/afflib
	dev-libs/boost
	dev-libs/openssl
	net-libs/http-parser
	pcap? ( net-libs/libpcap )
	sys-libs/zlib
	cairo? (
		x11-libs/cairo
	)
"
DEPEND="
	${RDEPEND}
	test? ( sys-apps/coreutils )
"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${WORKDIR}"/debian/patches/*.patch

	mv -f README{.md,} || die

	sed -i -e 's:`md5 -q \(.*\)`:`md5sum \1 | cut -f1 -d" "`:' tests/*.sh || die

	eautoreconf
}

src_configure() {
	econf \
		$(usex pcap --enable-pcap=true --enable-pcap=false) \
		$(usex cairo --enable-cairo=true --enable-cairo=false) \
		--without-o3
}
