# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3

DESCRIPTION="A utility for finding, fingerprinting and testing IKE VPN servers"
HOMEPAGE="https://github.com/royhills/ike-scan/"
EGIT_REPO_URI="https://github.com/royhills/ike-scan"

LICENSE="GPL-2"
SLOT="0"
IUSE="ssl"
KEYWORDS=""

DEPEND="
	ssl? (
		dev-libs/openssl:0=
	)
"
RDEPEND="
	${DEPEND}
"

src_prepare() {
	# Fix buffer overflow, bug #277556
	sed \
		-e "/MAXLINE/s:255:511:g" \
		-i ike-scan.h || die

	default

	eautoreconf
}

src_configure() {
	econf $(use_with ssl openssl)
}

src_install() {
	default
	dodoc udp-backoff-fingerprinting-paper.txt
}
