# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils

DESCRIPTION="DNSSEC validator (dnsval)"
HOMEPAGE="https://www.dnssec-tools.org/"
SRC_URI="https://www.dnssec-tools.org/download/dnsval-${PV}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="ipv6 static-libs +threads +ecdsa-check"

RDEPEND="dev-libs/openssl:0
	ecdsa-check? ( dev-libs/openssl:0[-bindist] )
	!<net-dns/dnssec-tools-1.13"
DEPEND="${RDEPEND}"

S=${WORKDIR}/dnsval-${PV}

PATCHES=( "${FILESDIR}"/${PN}-2.1-respect-LDFLAGS.patch
	"${FILESDIR}"/${P}-glib-2.25.patch )

src_configure() {
	econf \
		--with-nsec3 \
		--with-dlv \
		$(use_with ipv6) \
		$(use_with threads) \
		$(use_enable ecdsa-check)
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
