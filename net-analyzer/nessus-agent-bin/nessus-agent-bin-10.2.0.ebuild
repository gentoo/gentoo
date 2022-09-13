# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit rpm systemd

MY_P="NessusAgent-${PV}-es8"

DESCRIPTION="A remote security scanner for Linux - agent component"
HOMEPAGE="https://www.tenable.com/"
SRC_URI="${MY_P}.x86_64.rpm"

LICENSE="GPL-2 Nessus-EULA"
SLOT="0"
KEYWORDS="-* ~amd64"

RESTRICT="mirror fetch strip"

QA_PREBUILT="opt/nessus_agent/bin/nasl
	opt/nessus_agent/bin/nessus-mkrand
	opt/nessus_agent/lib/nessus/libjemalloc.so.*
	opt/nessus_agent/lib/nessus/libnessus-glibc-fix.so
	opt/nessus_agent/lib/nessus/iconv/*.so
	opt/nessus_agent/sbin/nessus-agent-module
	opt/nessus_agent/sbin/nessus-check-signature
	opt/nessus_agent/sbin/nessus-service
	opt/nessus_agent/sbin/nessuscli
	opt/nessus_agent/sbin/nessusd"

S="${WORKDIR}"

pkg_nofetch() {
	einfo "Please download ${A} from ${HOMEPAGE}downloads/nessus-agents"
	einfo "The archive should then be placed into your DISTDIR directory."
}

src_install() {
	# Using doins -r would strip executable bits from all binaries
	cp -pPR "${S}"/opt "${D}"/ || die "Failed to copy files"

	# Make sure these originally empty directories do not vanish,
	# Nessus will not run properly without them
	keepdir /opt/nessus_agent/com/nessus/CA
	keepdir /opt/nessus_agent/etc/nessus
	keepdir /opt/nessus_agent/var/nessus/logs
	keepdir /opt/nessus_agent/var/nessus/tmp
	keepdir /opt/nessus_agent/var/nessus/users

	newinitd "${FILESDIR}"/nessusagent.initd nessusagent
	systemd_dounit usr/lib/systemd/system/nessusagent.service
}

pkg_postinst() {
	# Actually update Nessus core components. According to upstream packages,
	# harmless to invoke on fresh installations too - and it may make life easier
	# for people who had restored Nessus state from backups, had it lying around
	# from older installations and so on.
	"${EROOT}"/opt/nessus_agent/sbin/nessuscli install "${EROOT}"/opt/nessus_agent/var/nessus/plugins-core.tar.gz

	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		elog "In order to link the agent to Tenable.io or an instance of Nessus Manager,"
		elog "obtain an appropriate linking key and run"
		elog ""
		elog "  /opt/nessus_agent/sbin/nessuscli agent link --key=<key> --host=<host> --port=<port> [optional parameters]"
		elog ""
		elog "This can be done before the agent is started."
	else
		elog "Please restart the nessusagent service to complete the update process"
	fi
}
