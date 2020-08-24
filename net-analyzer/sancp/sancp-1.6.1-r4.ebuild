# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs user

DESCRIPTION="collect network traffic statistics and store them in pcap format"
HOMEPAGE="https://sourceforge.net/projects/sancp/"
SRC_URI="
	http://www.metre.net/files/${P}.tar.gz
	http://sancp.sourceforge.net/${PN}-1.6.1.fix200511.a.patch
	http://sancp.sourceforge.net/${PN}-1.6.1.fix200511.b.patch
	http://sancp.sourceforge.net/${PN}-1.6.1.fix200601.c.patch
	http://sancp.sourceforge.net/${PN}-1.6.1.fix200606.d.patch
"

LICENSE="QPL GPL-2"

SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="sguil"

RDEPEND="net-libs/libpcap"
DEPEND="${RDEPEND}"

pkg_setup() {
	enewgroup sancp
	enewuser sancp -1 -1 /dev/null sancp
}

src_prepare() {
	epatch "${DISTDIR}"/${PN}-1.6.1.fix200511.a.patch
	epatch "${DISTDIR}"/${PN}-1.6.1.fix200511.b.patch
	# bug 138337
	epatch "${DISTDIR}"/${PN}-1.6.1.fix200601.c.patch
	epatch "${DISTDIR}"/${PN}-1.6.1.fix200606.d.patch
	epatch "${FILESDIR}"/${P}-compiler.patch
	epatch "${FILESDIR}"/${P}-gcc6.patch

	tc-export CXX CC
}

src_install() {
	keepdir /var/log/sancp/
	dodoc docs/CHANGES docs/fields.LIST docs/README docs/SETUP \
		"${FILESDIR}"/sguil_sancp.conf etc/sancp/sancp.conf

	insinto /etc/sancp
	if use sguil ; then
		newins "${FILESDIR}"/sguil_sancp.conf sancp.conf
	else
		doins etc/sancp/sancp.conf
	fi

	dobin sancp

	newinitd "${FILESDIR}"/sancp.rc1 sancp
	newconfd "${FILESDIR}"/sancp.confd sancp
	if use sguil ; then
		sed -i -e /^SANCP_OPTS/s:'sancp':"sguil":g \
			-e s:'-d $LOGDIR/today':"-d /var/lib/sguil/$(hostname)/sancp": \
			"${D}/etc/conf.d/sancp"
	fi

	fowners sancp:sancp /var/log/sancp
	fperms 0770 /var/log/sancp
}
