# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/teamspeak-server-bin/teamspeak-server-bin-3.0.11.3.ebuild,v 1.1 2015/08/02 13:00:19 jlec Exp $

EAPI=5

inherit eutils multilib systemd user

DESCRIPTION="Voice Communication Software - Server"
HOMEPAGE="http://www.teamspeak.com/"
SRC_URI="
	amd64? ( http://ftp.4players.de/pub/hosted/ts3/releases/${PV}/teamspeak3-server_linux-amd64-${PV}.tar.gz )
	x86? ( http://ftp.4players.de/pub/hosted/ts3/releases/${PV}/teamspeak3-server_linux-x86-${PV}.tar.gz )"

SLOT="0"
LICENSE="teamspeak3 GPL-2"
IUSE="doc pdf tsdns"
KEYWORDS="~amd64 ~x86"

RESTRICT="installsources fetch mirror strip"

S="${WORKDIR}/teamspeak3-server_linux-${ARCH}"

QA_PREBUILT="/opt/*"

pkg_nofetch() {
	elog "Please download ${A}"
	elog "from ${HOMEPAGE}?page=downloads and place this"
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
	newsbin ts3server_linux_${ARCH} ts3server-bin
	doexe *.sh
	doins *.so
	doins -r sql

	# Install documentation and tsdns.
	dodoc -r CHANGELOG doc/*.txt
	use doc && dodoc -r serverquerydocs doc/*.pdf && \
		docompress -x /usr/share/doc/${PF}/serverquerydocs && \
		dosym ../../usr/share/doc/${PF}/serverquerydocs  ${opt_dir}/serverquerydocs

	if use tsdns; then
		newsbin tsdns/tsdnsserver_linux_${ARCH} tsdnsserver

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
	systemd_dounit "${FILESDIR}"/systemd/teamspeak3.service
	systemd_dotmpfilesd "${FILESDIR}"/systemd/teamspeak3.conf

	# Fix up permissions.
	fowners teamspeak3 /{etc,var/{lib,log}}/teamspeak3-server
	fowners teamspeak3 ${opt_dir}

	fperms 700 /{etc,var/{lib,log}}/teamspeak3-server
	fperms 755 ${opt_dir}
}
