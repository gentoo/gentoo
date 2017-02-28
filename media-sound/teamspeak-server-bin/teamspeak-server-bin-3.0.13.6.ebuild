# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit multilib systemd user

DESCRIPTION="Crystal Clear Cross-Platform Voice Communication Server"
HOMEPAGE="https://www.teamspeak.com/"
SRC_URI="
	amd64? ( http://ftp.4players.de/pub/hosted/ts3/releases/${PV}/teamspeak3-server_linux_amd64-${PV}.tar.bz2 )
	x86? ( http://ftp.4players.de/pub/hosted/ts3/releases/${PV}/teamspeak3-server_linux_x86-${PV}.tar.bz2 )"

SLOT="0"
LICENSE="teamspeak3 GPL-2"
IUSE="doc tsdns"
KEYWORDS="~amd64 ~x86"

RESTRICT="installsources fetch mirror strip"

S="${WORKDIR}/teamspeak3-server_linux_${ARCH}"

QA_PREBUILT="opt/*"

pkg_nofetch() {
	elog "Please download ${A}"
	elog "from ${HOMEPAGE}downloads and place this"
	elog "file in ${DISTDIR}"
}

pkg_setup() {
	enewuser teamspeak3
}

src_install() {
	# Install wrapper
	dosbin "${FILESDIR}"/ts3server

	# Install TeamSpeak 3 server into /opt/teamspeak3-server.
	local opt_dir="/opt/teamspeak3-server"
	into ${opt_dir}
	insinto ${opt_dir}
	exeinto ${opt_dir}
	newsbin ts3server ts3server-bin
	doexe *.sh
	doins *.so
	doins -r sql

	# Install documentation and tsdns.
	dodoc -r CHANGELOG doc/*.txt
	use doc && dodoc -r serverquerydocs doc/serverquery && \
		docompress -x /usr/share/doc/${PF}/serverquerydocs && \
		docompress -x /usr/share/doc/${PF}/serverquery && \
		dosym ../../../usr/share/doc/${PF}/serverquery ${opt_dir}/doc/serverquery && \
		dosym ../../usr/share/doc/${PF}/serverquerydocs ${opt_dir}/serverquerydocs

	if use tsdns; then
		newsbin tsdns/tsdnsserver tsdnsserver
		newdoc tsdns/README README.tsdns
		newdoc tsdns/USAGE USAGE.tsdns
		dodoc tsdns/tsdns_settings.ini.sample
	fi

	# Install the runtime FS layout.
	insinto /etc/teamspeak3-server
	doins "${FILESDIR}"/server.conf "${FILESDIR}"/ts3db_mariadb.ini
	keepdir /{etc,var/{lib,log}}/teamspeak3-server

	# Install the init script and systemd unit.
	newinitd "${FILESDIR}"/${PN}-init-r1 teamspeak3-server
	systemd_newunit "${FILESDIR}"/systemd/teamspeak3-r1.service teamspeak3-server.service
	systemd_newtmpfilesd "${FILESDIR}"/systemd/teamspeak3.conf teamspeak3-server.conf

	# Fix up permissions.
	fowners teamspeak3 /{etc,var/{lib,log}}/teamspeak3-server
	fowners teamspeak3 ${opt_dir}

	fperms 700 /{etc,var/{lib,log}}/teamspeak3-server
	fperms 755 ${opt_dir}
}

pkg_postinst() {
	einfo "Starting with version 3.0.13, there are two important changes:"
	einfo "- IPv6 is now supported."
	einfo "- Binding to any address (0.0.0.0 / 0::0),"
	einfo "  instead of just the default ip of the network interface."
}
