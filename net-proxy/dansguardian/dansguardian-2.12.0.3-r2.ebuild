# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils user

DESCRIPTION="Web content filtering via proxy"
HOMEPAGE="http://www.${PN}.org"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"
IUSE="avast backtrace clamav commandline debug email +fancydm icap kaspersky +lfs logrotate ntlm orig-ip +pcre static-libs trickledm"

RDEPEND="sys-libs/zlib
	clamav? ( app-antivirus/clamav )
	logrotate? ( app-admin/logrotate )
	ntlm? ( virtual/libiconv )
	pcre? ( >=dev-libs/libpcre-8.32 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

WIKI="http://contentfilter.futuragts.com/wiki/doku.php"

pkg_setup() {
	enewgroup ${PN}
	enewuser ${PN} -1 -1 /dev/null ${PN}
}

src_configure() {
	local debug
	if use debug ; then
		debug="$(use_with debug dgdebug)"
	fi

	econf \
		$(use_enable avast avastd) \
		$(use_enable backtrace segv-backtrace) \
		$(use_enable clamav clamd) \
		$(use_enable commandline) \
		${debug} \
		$(use_enable email) \
		$(use_enable fancydm) \
		$(use_enable icap) \
		$(use_enable kaspersky kavd) \
		$(use_enable lfs) \
		--with-logdir=/var/log/${PN} \
		$(use_enable ntlm) \
		$(use_enable orig-ip) \
		$(use_enable pcre) \
		--with-piddir=/var/run \
		--with-proxygroup=${PN} \
		--with-proxyuser=${PN} \
		$(use_enable static-libs static-zlib) \
		$(use_enable trickledm)
}

src_install() {
	default

	# Edit config files for virus scanners chosen based on USE flags.
	if use avast; then
		sed -r -i -e 's/^#( *contentscanner *=.*avastdscan[.]conf.*)/\1/' "${D}/etc/${PN}/${PN}.conf"
	fi

	if use clamav; then
		sed -r -i -e 's/[ \t]+use dns/& clamd/' "${D}/etc/init.d/${PN}"
		sed -r -i -e 's/^#( *contentscanner *=.*clamdscan[.]conf.*)/\1/' "${D}/etc/${PN}/${PN}.conf"
	fi

	if use commandline; then
		sed -r -i -e 's/^#( *contentscanner *=.*commandlinescan[.]conf.*)/\1/' "${D}/etc/${PN}/${PN}.conf"
	fi

	if use icap; then
		sed -r -i -e 's/^#( *contentscanner *=.*icapscan[.]conf.*)/\1/' "${D}/etc/${PN}/${PN}.conf"
	fi

	if use kaspersky; then
		sed -r -i -e 's/^#( *contentscanner *=.*kavdscan[.]conf.*)/\1/' "${D}/etc/${PN}/${PN}.conf"
	fi

	# Install Gentoo init script
	newinitd "${FILESDIR}/${PN}.init" ${PN}

	# Install log rotation file.
	if use logrotate; then
		insinto /etc/logrotate.d
		newins "${FILESDIR}/${PN}.logrotate" ${PN}
	else
		exeinto /etc/cron.weekly
		newexe data/scripts/logrotation ${PN}.cron
	fi

	keepdir /var/log/${PN}
	fperms o-rwx /var/log/${PN}
}

pkg_postinst() {
	local runas="${PN}:${PN}"

	if [ -d "${ROOT}/var/log/${PN}" ] ; then
		chown -R ${runas} "${ROOT}/var/log/${PN}"
		chmod o-rwx "${ROOT}/var/log/${PN}"
	fi

	einfo "For assistance configuring ${PN}, visit the wiki at ${WIKI}"
}
