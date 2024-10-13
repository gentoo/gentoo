# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Network capture utility designed specifically for DNS traffic"
HOMEPAGE="https://dnscap.dns-oarc.net/"
SRC_URI="https://www.dns-oarc.net/files/dnscap/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/openssl:0=
	dev-perl/YAML
	net-libs/ldns:=
	net-libs/libpcap
	sys-libs/zlib
"
DEPEND="${RDEPEND}"

pkg_postinst() {
	elog "If you plan to use dnscap's -x/-X features, it is necessary to install"
	elog "net-dns/bind as well."
}
