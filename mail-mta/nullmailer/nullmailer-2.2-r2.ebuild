# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic systemd toolchain-funcs

DESCRIPTION="Simple relay-only local mail transport agent"
HOMEPAGE="http://untroubled.org/nullmailer/ https://github.com/bruceg/nullmailer"
SRC_URI="http://untroubled.org/${PN}/archive/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ~ppc64 ~riscv x86 ~x64-cygwin"
IUSE="ssl test"
RESTRICT="!test? ( test )"

BDEPEND="
	acct-group/nullmail
	acct-user/nullmail
"

DEPEND="
	ssl? ( net-libs/gnutls:0= )
	test? ( sys-apps/ucspi-tcp[ipv6] sys-process/daemontools )
"
RDEPEND="
	${BDEPEND}
	virtual/logger
	sys-apps/shadow
	ssl? ( net-libs/gnutls:0= )
	!mail-mta/courier
	!mail-mta/esmtp
	!mail-mta/exim
	!mail-mta/mini-qmail
	!mail-mta/msmtp[mta(+)]
	!mail-mta/netqmail
	!mail-mta/opensmtpd[mta(+)]
	!mail-mta/postfix
	!mail-mta/qmail-ldap
	!mail-mta/sendmail
	!mail-mta/ssmtp[mta(+)]
"

PATCHES=(
	"${FILESDIR}/${P}-fix-test-racecondition.patch"
	"${FILESDIR}/${P}-disable-dns-using-test.patch"
	"${FILESDIR}/${P}-disable-smtp-auth-tests.patch"
	"${FILESDIR}/${P}-c++11.patch"
)

src_prepare() {
	default
	sed -i.orig \
		-e '/\$(localstatedir)\/trigger/d' \
		"${S}"/Makefile.am || die
	sed \
		-e "s:^AC_PROG_RANLIB:AC_CHECK_TOOL(AR, ar, false)\nAC_PROG_RANLIB:g" \
		-i configure.ac || die
	sed -e "s/AM_CONFIG_HEADER/AC_CONFIG_HEADERS/" -i configure.ac || die
	sed \
		-e "s#/usr/local#/usr#" \
		-e 's:/usr/etc/:/etc/:g' \
		-i doc/nullmailer-send.8 || die
	eautoreconf
}

src_configure() {
	# https://github.com/bruceg/nullmailer/pull/31/commits
	append-lfs-flags #471102
	econf \
		--localstatedir="${EPREFIX}"/var \
		$(use_enable ssl tls)
}

src_compile() {
	tc-export AR RANLIB
	default
}

src_install() {
	default

	# A small bit of sample config
	insinto /etc/nullmailer
	newins "${FILESDIR}"/remotes.sample-2.0 remotes

	# This contains passwords, so should be secure
	fperms 0640 /etc/nullmailer/remotes
	fowners root:nullmail /etc/nullmailer/remotes

	# daemontools stuff
	dodir /var/spool/nullmailer/service{,/log}

	insinto /var/spool/nullmailer/service
	newins scripts/nullmailer.run run
	fperms 700 /var/spool/nullmailer/service/run

	insinto /var/spool/nullmailer/service/log
	newins scripts/nullmailer-log.run run
	fperms 700 /var/spool/nullmailer/service/log/run

	# usability
	dosym ../sbin/sendmail usr/$(get_libdir)/sendmail

	# permissions stuff
	keepdir /var/log/nullmailer /var/spool/nullmailer/{tmp,queue,failed}
	fperms 770 /var/log/nullmailer
	fowners nullmail:nullmail /usr/sbin/nullmailer-queue /usr/bin/mailq
	fperms 4711 /usr/sbin/nullmailer-queue /usr/bin/mailq

	newinitd "${FILESDIR}"/init.d-nullmailer-r6 nullmailer
	systemd_dounit scripts/${PN}.service
}

pkg_postinst() {
	if [[ ! -e ${EROOT}/var/spool/nullmailer/trigger ]]; then
		mkfifo --mode=0660 "${EROOT}/var/spool/nullmailer/trigger" || die
	fi
	chown nullmail:nullmail \
		"${EROOT}"/var/log/nullmailer \
		"${EROOT}"/var/spool/nullmailer/{tmp,queue,failed,trigger} || die
	chmod 770 \
		"${EROOT}"/var/log/nullmailer \
		"${EROOT}"/var/spool/nullmailer/{tmp,queue,failed} || die
	chmod 660 "${EROOT}"/var/spool/nullmailer/trigger || die

	# This contains passwords, so should be secure
	chmod 0640 "${EROOT}"/etc/nullmailer/remotes || die
	chown root:nullmail "${EROOT}"/etc/nullmailer/remotes || die

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		elog "To create an initial setup, please do:"
		elog "emerge --config =${CATEGORY}/${PF}"
	fi
}

pkg_postrm() {
	if [[ -e ${EROOT}/var/spool/nullmailer/trigger ]]; then
		rm "${EROOT}/var/spool/nullmailer/trigger" || die
	fi
}

pkg_config() {
	if [[ ! -s ${EROOT}/etc/nullmailer/me ]]; then
		einfo "Setting /etc/nullmailer/me"
		hostname --fqdn > "${EROOT}/etc/nullmailer/me"
		if [[ ! -s ${EROOT}/etc/nullmailer/me ]]; then
			eerror "Got no output from 'hostname --fqdn'"
		fi
	fi
	if [[ ! -s ${EROOT}/etc/nullmailer/defaultdomain ]]; then
		einfo "Setting /etc/nullmailer/defaultdomain"
		hostname --domain > "${EROOT}/etc/nullmailer/defaultdomain"
		if [[ ! -s ${EROOT}/etc/nullmailer/me ]]; then
			eerror "Got no output from 'hostname --domain'"
		fi
	fi
	if ! grep -q '^[ \t]*[^# \t]' "${EROOT}/etc/nullmailer/remotes"; then
		ewarn "Remember to tweak ${EROOT}/etc/nullmailer/remotes yourself!"
	fi
}
