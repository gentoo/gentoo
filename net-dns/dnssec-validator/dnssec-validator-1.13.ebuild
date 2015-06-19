# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-dns/dnssec-validator/dnssec-validator-1.13.ebuild,v 1.3 2013/03/13 10:08:38 xmw Exp $

EAPI=4

inherit eutils

DESCRIPTION="DNSSEC validator (dnsval)"
HOMEPAGE="http://www.dnssec-tools.org/"
SRC_URI="http://www.dnssec-tools.org/download/dnsval-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="ipv6 static-libs +threads"

RDEPEND="dev-libs/openssl
	!<net-dns/dnssec-tools-1.13"
DEPEND="${RDEPEND}"

S=${WORKDIR}/dnsval-${PV}

src_prepare() {
	epatch "${FILESDIR}"/${P}-respect-LDFLAGS.patch
}

src_configure() {
	econf \
		--with-nsec3 \
		--with-dlv \
		$(use_with ipv6) \
		$(use_with threads)
}

src_install() {
	dodir /usr/bin /usr/include/validator
	default

	insinto /etc/dnssec-tools
	doins etc/{dnsval.conf,root.hints}
	elog "Creating /etc/dnssec-tools/resolv.conf as symlink to /etc/resolv.conf"
	dosym ../resolv.conf /etc/dnssec-tools/resolv.conf

	use static-libs || find "${D}" -name "*.a" -delete
	prune_libtool_files
}
