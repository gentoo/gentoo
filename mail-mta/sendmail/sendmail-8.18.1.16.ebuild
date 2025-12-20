# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# Note: please bump this together with mail-filter/libmilter and app-shells/smrsh

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/sendmail.asc"
inherit systemd toolchain-funcs verify-sig

DESCRIPTION="Widely-used Mail Transport Agent (MTA)"
HOMEPAGE="https://www.sendmail.org/"
if [[ -n $(ver_cut 4) ]] ; then
	# Snapshots have an extra version component (e.g. 8.17.1 vs 8.17.1.9)
	SRC_URI="
		https://ftp.sendmail.org/snapshots/${PN}.${PV}.tar.gz
		verify-sig? ( https://ftp.sendmail.org/snapshots/${PN}.${PV}.tar.gz.sig )
	"
fi

SRC_URI+="
	https://ftp.sendmail.org/${PN}.${PV}.tar.gz
	verify-sig? ( https://ftp.sendmail.org/${PN}.${PV}.tar.gz.sig )
"
SRC_URI+="
	https://ftp.sendmail.org/past-releases/${PN}.${PV}.tar.gz
	verify-sig? ( https://ftp.sendmail.org/past-releases/${PN}.${PV}.tar.gz.sig )
"

LICENSE="Sendmail GPL-2" # GPL-2 is here for initscript
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="+berkdb eai fips ldap mbox nis sasl selinux ssl tcpd tinycdb"
REQUIRED_USE="
	|| ( berkdb tinycdb )
	fips? ( ssl )
"

DEPEND="
	acct-group/smmsp
	>=acct-user/smmsp-0-r2
	net-mail/mailbase
	berkdb? ( >=sys-libs/db-3.2:= )
	eai? ( dev-libs/icu:= )
	elibc_musl? ( virtual/libcrypt:= )
	ldap? ( net-nds/openldap:= )
	nis? ( net-libs/libnsl:= )
	sasl? ( >=dev-libs/cyrus-sasl-2.1.10 )
	ssl? (
		>=dev-libs/openssl-1.1.1:=
		fips? ( >=dev-libs/openssl-3:=[fips] )
	)
	tcpd? ( sys-apps/tcp-wrappers )
	tinycdb? ( dev-db/tinycdb )
"
RDEPEND="
	${DEPEND}
	>=mail-filter/libmilter-1.0.2_p2
	sys-devel/m4
	!mail-mta/courier
	!mail-mta/esmtp
	!mail-mta/exim
	!mail-mta/msmtp[mta]
	!mail-mta/netqmail
	!mail-mta/notqmail
	!mail-mta/nullmailer
	!mail-mta/opensmtpd
	!mail-mta/postfix
	!>=mail-mta/ssmtp-2.64-r2[mta]
	selinux? ( sec-policy/selinux-sendmail )
"
BDEPEND="
	sys-devel/m4
	virtual/pkgconfig
	verify-sig? ( ~sec-keys/openpgp-keys-sendmail-20250220 )
"
PDEPEND="
	!mbox? (
		|| (
			mail-filter/procmail
			mail-filter/maildrop
		)
	)
"
PATCHES=(
	"${FILESDIR}"/${PN}-8.13.1-delivered_hdr.patch
	"${FILESDIR}"/${PN}-8.16.1-build-system.patch
)

src_prepare() {
	default

	local confCCOPTS="${CFLAGS}"
	local confENVDEF="-DMAXDAEMONS=64 -DHAS_GETHOSTBYNAME2=1"
	local confLDOPTS="${LDFLAGS}"
	local confLIBS=
	local confMAPDEF="-DMAP_REGEX"
	local conf_sendmail_LIBS=

	# Always enable ipv6 and sockets
	confENVDEF+=" -DNETINET6 -DSOCKETMAP"

	# Enable experimental features
	confENVDEV+=" -D_FFR_SAMEDOMAIN -D_FFR_MF_ONEDOMAIN"

	if use berkdb; then
		# See bug #808954 for FLOCK
		confENVDEF+=" -DHASFLOCK=1"
		confMAPDEF+=" -DNEWDB"
		confLIBS+=" -ldb"
	else
		confMAPDEF+=" -UNEWDB"
	fi

	if use eai; then
		confCCOPTS+=" $($(tc-getPKG_CONFIG) --cflags icu-uc)"
		confENVDEF+=" -DUSE_EAI"
		confLIBS+=" $($(tc-getPKG_CONFIG) --libs icu-uc)"
	fi

	if use ldap; then
		confMAPDEF+=" -DLDAPMAP"
		confLIBS+=" -lldap -llber"
	fi

	use nis && confENVDEF+=" -DNIS"

	if use sasl; then
		confCCOPTS+=" $($(tc-getPKG_CONFIG) --cflags libsasl2)"
		confENVDEF+=" -DSASL=2"
		conf_sendmail_LIBS+=" $($(tc-getPKG_CONFIG) --libs libsasl2)"
	fi

	if use ssl; then
		# Bug #542370 - lets add support for modern crypto (PFS)
		confCCOPTS+=" $($(tc-getPKG_CONFIG) --cflags openssl)"
		confENVDEF+=" -DSTARTTLS -D_FFR_DEAL_WITH_ERROR_SSL"
		confENVDEF+=" -D_FFR_TLS_1 -D_FFR_TLS_EC"
		# Bug #944822 - fix certification chain with intermediate cert file
		confENVDEF+=" -D_FFR_TLS_USE_CERTIFICATE_CHAIN_FILE"
		confENVDEF+=" -DDANE"

		if use fips; then
			confENVDEF+=" -D_FFR_FIPSMODE"
		fi

		conf_sendmail_LIBS+=" $($(tc-getPKG_CONFIG) --libs openssl)"
	fi

	if use tcpd; then
		confENVDEF+=" -DTCPWRAPPERS"
		confLIBS+=" -lwrap"
	fi

	if use tinycdb; then
		confMAPDEF+=" -DCDB=2"
		confLIBS+=" -lcdb"
	else
		confMAPDEF+=" -UCDB"
	fi

	if use elibc_musl; then
		confENVDEF+=" -DHASSTRERROR -DHASRRESVPORT=0 -DNEEDSGETIPNODE"

		eapply "${FILESDIR}"/${PN}-musl-stack-size.patch
		eapply "${FILESDIR}"/${PN}-musl-disable-cdefs.patch
	fi

	sed -e "s|@@confCC@@|$(tc-getCC)|" \
		-e "s|@@confCCOPTS@@|${confCCOPTS}|" \
		-e "s|@@confENVDEF@@|${confENVDEF}|" \
		-e "s|@@confLDOPTS@@|${confLDOPTS}|" \
		-e "s|@@confLIBS@@|${confLIBS}|" \
		-e "s|@@confMAPDEF@@|${confMAPDEF}|" \
		-e "s|@@conf_sendmail_LIBS@@|${conf_sendmail_LIBS}|" \
		"${FILESDIR}"/site.config.m4 > devtools/Site/site.config.m4 \
		|| die "failed to generate site.config.m4"

	echo "APPENDDEF(\`confLIBDIRS', \`-L${EPREFIX}/usr/$(get_libdir)')" \
		>> devtools/Site/site.config.m4 || die "failed adding to site.config.m4"
}

src_compile() {
	sh Build AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" || die "compilation failed in main build script"
}

src_install() {
	dodir /usr/{bin,$(get_libdir)}
	dodir /usr/share/man/man{1,5,8} /usr/sbin /usr/share/sendmail-cf
	dodir /var/spool/{mqueue,clientmqueue} /etc/conf.d

	keepdir /var/spool/{clientmqueue,mqueue}

	local emakeargs=(
		DESTDIR="${D}" LIBDIR="/usr/$(get_libdir)"
		MANROOT=/usr/share/man/man
		SBINOWN=root SBINGRP=root UBINOWN=root UBINGRP=root
		MANOWN=root MANGRP=root INCOWN=root INCGRP=root
		LIBOWN=root LIBGRP=root GBINOWN=root GBINGRP=root
		MSPQOWN=root CFOWN=root CFGRP=root
	)

	local dir
	for dir in libsmutil sendmail mailstats praliases smrsh makemap vacation editmap; do
		emake -j1 -C obj.*/${dir} "${emakeargs[@]}" install
	done
	for dir in rmail mail.local; do
		emake -j1 -C obj.*/${dir} "${emakeargs[@]}" force-install
	done

	fowners root:smmsp /usr/sbin/sendmail
	fperms 2555 /usr/sbin/sendmail
	fowners smmsp:smmsp /var/spool/clientmqueue
	fperms 770 /var/spool/clientmqueue
	fperms 700 /var/spool/mqueue
	dodoc FAQ KNOWNBUGS README RELEASE_NOTES doc/op/op.ps SNAPSHOT_NOTES

	dodoc sendmail/{SECURITY,TUNING}
	newdoc sendmail/README README.sendmail
	newdoc smrsh/README README.smrsh

	newdoc cf/README README.cf
	newdoc cf/cf/README README.install-cf

	dodoc -r contrib

	cp -pPR cf/. "${ED}"/usr/share/sendmail-cf || die

	insinto /etc/mail
	if use mbox; then
		newins "${FILESDIR}"/sendmail.mc-r1 sendmail.mc
	else
		newins "${FILESDIR}"/sendmail-maildir.mc sendmail.mc
	fi

	# See discussion on bug #730890
	m4 "${ED}"/usr/share/sendmail-cf/m4/cf.m4 \
		<(grep -v "${EPREFIX}"/usr/share/sendmail-cf/m4/cf.m4 "${ED}"/etc/mail/sendmail.mc) \
		> "${ED}"/etc/mail/sendmail.cf || die "cf.m4 failed"

	echo "include(\`/usr/share/sendmail-cf/m4/cf.m4')dnl" \
		> "${ED}"/etc/mail/submit.mc || die "submit.mc echo failed"

	cat "${ED}"/usr/share/sendmail-cf/cf/submit.mc \
		>> "${ED}"/etc/mail/submit.mc || die "submit.mc cat failed"

	echo "# local-host-names - include all aliases for your machine here" \
		> "${ED}"/etc/mail/local-host-names || die "local-host-names echo failed"

	cat <<- EOF > "${ED}"/etc/mail/trusted-users || die "trusted-users cat failed"
		# trusted-users - users that can send mail as others without a warning
		# apache, mailman, majordomo, uucp are good candidates
	EOF

	cat <<- EOF > "${ED}"/etc/mail/access || die "access cat failed"
		# Check the ${EPREFIX}/usr/share/sendmail-cf/README file for a description
		# of the format of this file. (search for access_db in that file)
		#

	EOF

	cat <<- EOF > "${ED}"/etc/conf.d/sendmail || die "sendmail cat failed"
		# Config file for /etc/init.d/sendmail
		# add start-up options here
		SENDMAIL_OPTS="-bd -q30m -L sm-mta" # default daemon mode
		CLIENTMQUEUE_OPTS="-Ac -q30m -L sm-cm" # clientmqueue
		KILL_OPTS="" # add -9/-15/your favorite evil SIG level here

	EOF

	if use sasl; then
		dodir /etc/sasl2
		cat <<- EOF > "${ED}"/etc/sasl2/Sendmail.conf || die "Sendmail.conf cat failed"
			pwcheck_method: saslauthd
			mech_list: PLAIN LOGIN

		EOF
	fi

	doinitd "${FILESDIR}"/sendmail
	systemd_dounit "${FILESDIR}"/sendmail.service
	systemd_dounit "${FILESDIR}"/sm-client.service
}

pkg_postinst() {
	if ! use berkdb; then
		ewarn "If your configuration relies on userdb, you should install"
		ewarn "this package with USE=berkdb."
	fi

	if ! use mbox; then
		elog "Starting with mail-mta/sendmail-8.18.1 you could use either"
		elog "procmail or maildrop to use maildir-style mailbox in user's home directory."
		elog ""
		elog "If you prefer procmail (default), emerge mail-filter/procmail with USE=-mbox"
		elog "and include the following lines in sendmail.mc to create your sendmail.cf"
		elog "configuration file:"
		elog "\tFEATURE(\`local_procmail')dnl"
		elog "\tMAILER(\`procmail')dnl"
		elog ""
		elog "If you prefer maildrop, you'll need to ensure that you configure a mail"
		elog "storage location using DEFAULT in /etc/maildroprc, for example:"
		elog "\tDEFAULT=\$HOME/.maildir"
		elog ""
		elog "and include the following line in sendmail.mc to create your sendmail.cf"
		elog "configuration file:"
		elog "\tFEATURE(\`local_procmail',\`/usr/bin/maildrop',\`maildrop -d $u')dnl"
	fi

	ewarn "This version has enabled experimental code. Please read the file"
	ewarn ""
	ewarn "\t${EPREFIX}/usr/share/doc/${PF}/SNAPSHOT_NOTES"
	ewarn ""
	ewarn "for enable testing, provide feedback and report potential problems"
	ewarn "directly to upstream."
}
