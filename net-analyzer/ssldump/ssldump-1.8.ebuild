# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="An SSLv3/TLS network protocol analyzer"
HOMEPAGE="https://github.com/adulau/ssldump/"
SRC_URI="https://github.com/adulau/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="openssl"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ~sparc x86"

RDEPEND="dev-libs/json-c:=
	dev-libs/openssl:=
	net-libs/libnet:1.1
	net-libs/libpcap"
DEPEND="${RDEPEND}"

src_install() {
	dosbin "${BUILD_DIR}"/${PN}
	doman ${PN}.1
	einstalldocs
}
