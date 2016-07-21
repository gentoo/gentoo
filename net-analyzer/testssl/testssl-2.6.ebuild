# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_PN="${PN}.sh"

DESCRIPTION="Tool to check TLS/SSL cipher support"
HOMEPAGE="https://testssl.sh/"
SRC_URI="https://github.com/drwetter/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2 bundled-openssl? ( openssl )"
SLOT="0"
KEYWORDS="~amd64"
IUSE="bundled-openssl"

RDEPEND="
	dev-libs/openssl:0
	net-dns/bind-tools
	sys-apps/util-linux
"

S=${WORKDIR}/${MY_PN}-${PV}

QA_PREBUILT="opt/${PN}/*"

pkg_setup() {
	use amd64 && BUNDLED_OPENSSL="openssl.Linux.x86_64"
}

src_prepare() {
	sed -i -e "s|MAPPING_FILE_RFC=\"\"|MAPPING_FILE_RFC=\"/usr/share/${PN}/mapping-rfc.txt\"|" ${PN}.sh || die
}

src_install() {
	dodoc CHANGELOG.stable-releases.txt CREDITS.md Readme.md
	dodoc openssl-rfc.mappping.html

	dobin ${PN}.sh

	insinto /usr/share/${PN}
	doins mapping-rfc.txt

	if use bundled-openssl; then
		exeinto /opt/${PN}
		use amd64 && doexe bin/${BUNDLED_OPENSSL}
	fi
}

pkg_postinst() {
	if use bundled-openssl; then
		einfo "A precompiled version of OpenSSL has been installed into /opt/${PN},"
		einfo "configured to enable a wider range of features to allow better testing."
		einfo ""
		einfo "To use it, call ${PN} appropriately:"
		einfo "${MY_PN} --openssl /opt/${PN}/${BUNDLED_OPENSSL} example.com"
	fi
}
