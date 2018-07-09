# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A driver for NTPd for people who are firewall-challenged"
HOMEPAGE="https://www.vanheusden.com/time/omnisync"
LICENSE="GPL-2"
SRC_URI="https://www.vanheusden.com/time/${PN}/${P}.tgz"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="dev-libs/openssl:0= net-analyzer/net-snmp:="
DEPEND="${RDEPEND}"
DOCS=( readme.txt Changes )

src_prepare() {
	default
	tc-export CC
	sed -i -e 's/-O2 -Wall/-Wall/' -e 's/-lsnmp/-lnetsnmp/' "${S%/}/Makefile" || die
	use debug ||  sed -i -e 's/$(DEBUG)//' "${S%/}/Makefile" || die
}

src_install() {
	dosbin omnisync
	newinitd "${FILESDIR%/}/${PN}.initd" ${PN}
	newconfd "${FILESDIR%/}/${PN}.confd" ${PN}
	einstalldocs
}

pkg_postinst() {
	local isConfigured=$(grep 'OMNISYNC_MODE=""' "${ROOT%/}/etc/conf.d/${PN}")
	if [[ -n "${isConfigured}" ]] ; then
		elog "Be sure to configure ${PN} in ${ROOT%/}/etc/conf.d before trying to start the service"
	fi
}
