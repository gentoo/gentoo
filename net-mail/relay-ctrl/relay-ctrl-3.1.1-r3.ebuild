# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs fixheadtails

DESCRIPTION="SMTP Relaying Control designed for qmail & tcpserver"
HOMEPAGE="http://untroubled.org/relay-ctrl/"
SRC_URI="http://untroubled.org/relay-ctrl/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND=""
RDEPEND="sys-apps/ucspi-tcp
	virtual/daemontools"

RELAYCTRL_BASE="/var/spool/relay-ctrl"
# this is relative to RELAYCTRL_BASE
RELAYCTRL_STORAGE="allow"
RELAYCTRL_CONFDIR="/etc/relay-ctrl"
RELAYCTRL_BINDIR="/usr/bin"

src_prepare() {
	eapply_user
	ht_fix_file "${S}"/Makefile
	eapply "${FILESDIR}"/authenticated.c-relayfixup.diff
	eapply "${FILESDIR}"/relay-ctrl-3.1.1-NOFILE-overstep.patch
}

src_configure() {
	local myCC="$(tc-getCC)"
	echo "${myCC} ${CFLAGS}" > conf-cc || die
	echo "${myCC} ${LDFLAGS}" > conf-ld || die
}

src_install() {
	exeinto ${RELAYCTRL_BINDIR}
	doexe relay-ctrl-age relay-ctrl-allow relay-ctrl-check relay-ctrl-send relay-ctrl-udp relay-ctrl-chdir

	#NB: at some point the man page for relay-ctrl-chdir will be added!
	doman relay-ctrl-age.8 relay-ctrl-allow.8 relay-ctrl-check.8 relay-ctrl-send.8 relay-ctrl-udp.8
	dodoc README ANNOUNCEMENT NEWS

	keepdir ${RELAYCTRL_BASE} ${RELAYCTRL_BASE}/${RELAYCTRL_STORAGE}
	fperms 700 ${RELAYCTRL_BASE}
	# perm 777 is intentional, see http://untroubled.org/relay-ctrl/
	fperms 777 ${RELAYCTRL_BASE}/${RELAYCTRL_STORAGE}

	dodir ${RELAYCTRL_CONFDIR}

	# tell it our storage dir
	echo "${RELAYCTRL_BASE}/${RELAYCTRL_STORAGE}" \
		> ${D}${RELAYCTRL_CONFDIR}/RELAY_CTRL_DIR || die
	# default to 30 minutes
	echo "1800" > ${D}${RELAYCTRL_CONFDIR}/RELAY_CTRL_EXPIRY || die

	dodir /etc/cron.hourly
	echo "#!/bin/sh" > ${D}/etc/cron.hourly/relay-ctrl-age
	echo "/usr/bin/envdir ${RELAYCTRL_CONFDIR} ${RELAYCTRL_BINDIR}/relay-ctrl-age" \
		>> "${D}"/etc/cron.hourly/relay-ctrl-age
	fperms 755 /etc/cron.hourly/relay-ctrl-age
}

pkg_postinst() {
	if [[ -d /usr/lib/courier-imap/authlib ]]; then
		ln -sf /usr/bin/relay-ctrl-allow \
			/usr/lib/courier-imap/authlib/relay-ctrl-allow
	fi
	elog "Please see the instructions in /usr/share/doc/${PF}/README"
	elog "for setup instructions with Courier-IMAP and Qmail"

	einfo "Ensure that the relay-ctrl-age cronjob is running"
	einfo "otherwise your system may accumulate old relay entries."
}
