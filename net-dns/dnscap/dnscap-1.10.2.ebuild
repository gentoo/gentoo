# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Network capture utility designed specifically for DNS traffic"
HOMEPAGE="https://dnscap.dns-oarc.net/"
SRC_URI="https://www.dns-oarc.net/files/dnscap/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="ISC"
IUSE=""

RDEPEND="net-libs/libpcap
	net-libs/ldns
	sys-libs/zlib
	dev-libs/openssl:=
	dev-perl/YAML"

DEPEND="${RDEPEND}"

pkg_postinst() {
	elog "If you plan to use dnscap's -x/-X features, it is necessary to install"
	elog "net-dns/bind as well."
}
