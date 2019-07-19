# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit user

DESCRIPTION="NewRelic System Monitor"
HOMEPAGE="http://www.newrelic.com/"
SRC_URI="http://download.newrelic.com/server_monitor/archive/${PV}/${P}-linux.tar.gz"

LICENSE="newrelic Apache-2.0 MIT ISC openssl GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86"
IUSE=""
RESTRICT="strip"

S="${WORKDIR}/${P}-linux"

pkg_setup() {
	enewgroup newrelic
	enewuser newrelic -1 -1 -1 newrelic
}

src_install() {
	if [[ "${ARCH}" == "amd64" ]]; then
		NR_ARCH="x64"
	elif [[ "${ARCH}" == "x86" ]]; then
		NR_ARCH="x86"
	else
		die "Unsupported architecture (${ARCH})"
	fi

	dosbin "scripts/nrsysmond-config"
	newsbin "daemon/nrsysmond.${NR_ARCH}" "nrsysmond"
	newinitd "${FILESDIR}/newrelic-sysmond.rc" "newrelic-sysmond"

	keepdir "/etc/newrelic"
	insinto "/etc/newrelic"
	doins nrsysmond.cfg

	keepdir "/var/run/newrelic"
	fowners newrelic.newrelic "/var/run/newrelic"
	fperms 0775 "/var/run/newrelic"

	keepdir "/var/log/newrelic"
	fowners newrelic.newrelic "/var/log/newrelic"
	fperms 0775 "/var/log/newrelic"

	dodoc INSTALL.txt LICENSE.txt
}

pkg_postinst() {
	elog "Remember to set your license key via:"
	elog "$ nrsysmond-config --set license_key=\$YOUR_KEY"
}
