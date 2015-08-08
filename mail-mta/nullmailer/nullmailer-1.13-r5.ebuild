# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils flag-o-matic multilib systemd user

MY_P="${P/_rc/RC}"

DEBIAN_PV=1.11
DEBIAN_PR="2"
DEBIAN_P="${PN}-${DEBIAN_PV}"
DEBIAN_PF="${DEBIAN_P/-/_}-${DEBIAN_PR}"
DEBIAN_SRC="${DEBIAN_PF}.debian.tar.gz"

DESCRIPTION="Simple relay-only local mail transport agent"
HOMEPAGE="http://untroubled.org/nullmailer/"
SRC_URI="
	http://untroubled.org/${PN}/archive/${MY_P}.tar.gz
	http://dev.gentoo.org/~jlec/distfiles/${PN}-patches-${PV}.tar.xz"
#		mirror://debian/pool/main/n/${PN}/${DEBIAN_SRC}"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"
IUSE="ssl"

DEPEND="
	sys-apps/groff
	ssl? ( net-libs/gnutls )"
RDEPEND="
	virtual/logger
	virtual/shadow
	ssl? ( net-libs/gnutls )
	!mail-mta/courier
	!mail-mta/esmtp
	!mail-mta/exim
	!mail-mta/mini-qmail
	!mail-mta/msmtp
	!mail-mta/netqmail
	!mail-mta/postfix
	!mail-mta/qmail-ldap
	!mail-mta/sendmail
	!mail-mta/opensmtpd
	!mail-mta/ssmtp"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	enewgroup nullmail 88
	enewuser nullmail 88 -1 /var/nullmailer nullmail
}

src_prepare() {
#	sed -i -e 's/nullmailer-1.10/nullmailer-1.11/g' \
#		"${WORKDIR}"/debian/patches/*.diff || die
#	EPATCH_OPTS="-d ${S} -p1" \
#	epatch "${DISTDIR}"/${DEBIAN_SRC}
	# why revert?  Ask Robin when he is back!
#	EPATCH_OPTS="-d ${WORKDIR} -p0 -R" \
#	epatch "${WORKDIR}"/debian/patches/02_ipv6.diff
	# this fixes the debian daemon/syslog to actually compile

	# old debian patches from 1.11
	# DO NOT APPLY patch 0009... It breaks
	epatch "${WORKDIR}"/patches/000{1..8}*patch

	epatch "${FILESDIR}"/${P}-unistd.h.patch

	sed -i.orig \
		-e '/^nullmailer_send_LDADD/s, =, = ../lib/cli++/libcli++.a,' \
		"${S}"/src/Makefile.am || die "Sed failed"
	sed -i.orig \
		-e '/\$(localstatedir)\/trigger/d' \
		"${S}"/Makefile.am || die "Sed failed"
	sed \
		-e "s:^AC_PROG_RANLIB:AC_CHECK_TOOL(AR, ar, false)\nAC_PROG_RANLIB:g" \
		-i configure.in || die
	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.in || die
	eautoreconf
}

src_configure() {
	# Note that we pass a different directory below due to bugs in the makefile!
	econf \
		--localstatedir=/var \
		$(use_enable ssl tls)
}

src_install () {
	emake DESTDIR="${D}" localstatedir=/var/nullmailer install

	dodoc AUTHORS BUGS HOWTO INSTALL ChangeLog NEWS README TODO

	# A small bit of sample config
	insinto /etc/nullmailer
	newins "${FILESDIR}"/remotes.sample-${PV} remotes

	# This contains passwords, so should be secure
	fperms 0640 /etc/nullmailer/remotes
	fowners root:nullmail /etc/nullmailer/remotes

	# daemontools stuff
	dodir /var/nullmailer/service{,/log}

	insinto /var/nullmailer/service
	newins scripts/nullmailer.run run
	fperms 700 /var/nullmailer/service/run

	insinto /var/nullmailer/service/log
	newins scripts/nullmailer-log.run run
	fperms 700 /var/nullmailer/service/log/run

	# usability
	dosym /usr/sbin/sendmail usr/$(get_libdir)/sendmail

	# permissions stuff
	keepdir /var/log/nullmailer /var/nullmailer/{tmp,queue}
	fperms 770 /var/log/nullmailer /var/nullmailer/{tmp,queue}
	fowners nullmail:nullmail /usr/sbin/nullmailer-queue /usr/bin/mailq
	fperms 4711 /usr/sbin/nullmailer-queue /usr/bin/mailq

	newinitd "${FILESDIR}"/init.d-nullmailer-r4 nullmailer
	systemd_dounit "${FILESDIR}"/${PN}.service
}

pkg_postinst() {
	if [ ! -e "${ROOT}"/var/nullmailer/trigger ]; then
		mkfifo "${ROOT}"/var/nullmailer/trigger
	fi
	chown nullmail:nullmail \
		"${ROOT}"/var/log/nullmailer "${ROOT}"/var/nullmailer/{tmp,queue,trigger} || die
	chmod 770 "${ROOT}"/var/log/nullmailer "${ROOT}"/var/nullmailer/{tmp,queue} || die
	chmod 660 "${ROOT}"/var/nullmailer/trigger || die

	# This contains passwords, so should be secure
	chmod 0640 "${ROOT}"/etc/nullmailer/remotes || die
	chown root:nullmail "${ROOT}"/etc/nullmailer/remotes || die

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "To create an initial setup, please do:"
		elog "emerge --config =${CATEGORY}/${PF}"
	fi
	#echo
	#elog "To start nullmailer at boot you may use either the nullmailer init.d"
	#elog "script, or emerge sys-process/supervise-scripts, enable the"
	#elog "svscan init.d script and create the following link:"
	#elog "ln -fs /var/nullmailer/service /service/nullmailer"
	#echo
}

pkg_postrm() {
	if [[ -e "${ROOT}"/var/nullmailer/trigger ]]; then
		rm "${ROOT}"/var/nullmailer/trigger || die
	fi
}

pkg_config() {
	if [ ! -s "${ROOT}"/etc/nullmailer/me ]; then
		einfo "Setting /etc/nullmailer/me"
		/bin/hostname --fqdn > "${ROOT}"/etc/nullmailer/me
	fi
	if [ ! -s "${ROOT}"/etc/nullmailer/defaultdomain ]; then
		einfo "Setting /etc/nullmailer/defaultdomain"
		/bin/hostname --domain > "${ROOT}"/etc/nullmailer/defaultdomain
	fi
}
