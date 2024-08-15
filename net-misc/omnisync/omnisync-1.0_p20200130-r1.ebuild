# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic vcs-snapshot

SNAPSHOT="c55215330b1e8a61af6d34d57d3d8236c8cc7d5b"

DESCRIPTION="A driver for NTPd for people who are firewall-challenged"
HOMEPAGE="https://www.vanheusden.com/time/omnisync"
LICENSE="GPL-2"
SRC_URI="https://gitlab.com/grknight/omnisync/-/archive/${SNAPSHOT}/omnisync-${SNAPSHOT}.tar.bz2 -> ${P}.tar.bz2"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	net-analyzer/net-snmp:=
	net-libs/gnutls:=
"
DEPEND="${RDEPEND}"
DOCS=( readme.txt Changes )

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/861683
	# appears to be terminally dead
	filter-lto

	cmake_src_configure
}

src_install() {
	cmake_src_install
	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}
	einstalldocs
}

pkg_postinst() {
	local isConfigured=$(grep 'OMNISYNC_MODE=""' "${ROOT}/etc/conf.d/${PN}")
	if [[ -n "${isConfigured}" ]] ; then
		elog "Be sure to configure ${PN} in ${ROOT}/etc/conf.d before trying to start the service"
	fi
}
