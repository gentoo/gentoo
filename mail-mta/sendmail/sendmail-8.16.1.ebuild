# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib systemd toolchain-funcs

DESCRIPTION="Widely-used Mail Transport Agent (MTA)"
HOMEPAGE="https://www.sendmail.org/"
SRC_URI="ftp://ftp.sendmail.org/pub/${PN}/${PN}.${PV}.tar.gz"

LICENSE="Sendmail GPL-2" # GPL-2 is here for initscript
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="ipv6 ldap libressl mbox nis sasl sockets ssl tcpd"

BDEPEND="sys-devel/m4"
DEPEND="net-mail/mailbase
	sasl? ( >=dev-libs/cyrus-sasl-2.1.10 )
	tcpd? ( sys-apps/tcp-wrappers )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
	ldap? ( net-nds/openldap )
	>=sys-libs/db-3.2:=
	!net-mail/vacation"
RDEPEND="${DEPEND}
	acct-group/smmsp
	acct-user/smmsp
	>=net-mail/mailbase-0.00
	>=mail-filter/libmilter-1.0.2_p1-r1
	!mail-mta/courier
	!mail-mta/esmtp
	!mail-mta/exim
	!mail-mta/mini-qmail
	!mail-mta/msmtp[mta]
	!mail-mta/netqmail
	!mail-mta/nullmailer
	!mail-mta/postfix
	!mail-mta/opensmtpd
	!mail-mta/qmail-ldap
	!>=mail-mta/ssmtp-2.64-r2[mta]"

PDEPEND="!mbox? ( mail-filter/procmail )"

src_prepare() {
	eapply "${FILESDIR}"/"${PN}"-8.16.1-build-system.patch
	eapply -p0 "${FILESDIR}"/sendmail-delivered_hdr.patch

	local confCC="$(tc-getCC)"
	local confCCOPTS="${CFLAGS}"
	local confLDOPTS="${LDFLAGS}"
	local confMAPDEF="-DMAP_REGEX"
	local confENVDEF="-DMAXDAEMONS=64"
	local conf_sendmail_LIBS=""

	use sasl && confLIBS="${confLIBS} -lsasl2"  \
		&& confENVDEF="${confENVDEF} -DSASL=2" \
		&& confCCOPTS="${confCCOPTS} -I/usr/include/sasl" \
		&& conf_sendmail_LIBS="${conf_sendmail_LIBS} -lsasl2"

	use tcpd && confENVDEF="${confENVDEF} -DTCPWRAPPERS" \
		&& confLIBS="${confLIBS} -lwrap"

	# Bug #542370 - lets add support for modern crypto (PFS)
	use ssl && confENVDEF="${confENVDEF} -DSTARTTLS -D_FFR_DEAL_WITH_ERROR_SSL" \
		&& confENVDEF="${confENVDEF} -D_FFR_TLS_1 -D_FFR_TLS_EC" \
		&& confLIBS="${confLIBS} -lssl -lcrypto" \
		&& conf_sendmail_LIBS="${conf_sendmail_LIBS} -lssl -lcrypto"

	use ldap && confMAPDEF="${confMAPDEF} -DLDAPMAP" \
		&& confLIBS="${confLIBS} -lldap -llber"

	use ipv6 && confENVDEF="${confENVDEF} -DNETINET6"

	use nis && confENVDEF="${confENVDEF} -DNIS"

	use sockets && confENVDEF="${confENVDEF} -DSOCKETMAP"

	sed -e "s:@@confCCOPTS@@:${confCCOPTS}:" \
		-e "s/@@confLDOPTS@@/${confLDOPTS}/" \
		-e "s/@@confCC@@/${confCC}/" \
		-e "s/@@confMAPDEF@@/${confMAPDEF}/" \
		-e "s/@@confENVDEF@@/${confENVDEF}/" \
		-e "s/@@confLIBS@@/${confLIBS}/" \
		-e "s/@@conf_sendmail_LIBS@@/${conf_sendmail_LIBS}/" \
		"${FILESDIR}"/site.config.m4 > devtools/Site/site.config.m4 || die "sed failed"

	echo "APPENDDEF(\`confLIBDIRS', \`-L${EROOT}/usr/$(get_libdir)')" >> devtools/Site/site.config.m4 || die "echo failed"

	eapply_user
}

src_compile() {
	sh Build AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" || die "compilation failed in main build script"
}

src_install() {
	local MY_LIBDIR=/usr/$(get_libdir)
	local MY_OBJDIR="obj.`uname -s`.`uname -r`.`uname -m`"

	dodir /usr/bin ${MY_LIBDIR}
	dodir /usr/share/man/man{1,5,8} /usr/sbin /usr/share/sendmail-cf
	dodir /var/spool/{mqueue,clientmqueue} /etc/conf.d

	keepdir /var/spool/{clientmqueue,mqueue}

	for dir in libsmutil sendmail mailstats praliases smrsh makemap vacation editmap
	do
		make DESTDIR="${D}" LIBDIR="${MY_LIBDIR}" MANROOT=/usr/share/man/man \
			SBINOWN=root SBINGRP=root UBINOWN=root UBINGRP=root \
			MANOWN=root MANGRP=root INCOWN=root INCGRP=root \
			LIBOWN=root LIBGRP=root GBINOWN=root GBINGRP=root \
			MSPQOWN=root CFOWN=root CFGRP=root \
			install -C "${MY_OBJDIR}/${dir}" \
			|| die "install 1 failed"
	done

	for dir in rmail mail.local
	do
		make DESTDIR="${D}" LIBDIR="${MY_LIBDIR}" MANROOT=/usr/share/man/man \
			SBINOWN=root SBINGRP=root UBINOWN=root UBINGRP=root \
			MANOWN=root MANGRP=root INCOWN=root INCGRP=root \
			LIBOWN=root LIBGRP=root GBINOWN=root GBINGRP=root \
			MSPQOWN=root CFOWN=root CFGRP=root \
			force-install -C "${MY_OBJDIR}/${dir}" \
			|| die "install 2 failed"
	done

	fowners root:smmsp /usr/sbin/sendmail
	fperms 2555 /usr/sbin/sendmail
	fowners smmsp:smmsp /var/spool/clientmqueue
	fperms 770 /var/spool/clientmqueue
	fperms 700 /var/spool/mqueue
	dosym /usr/sbin/makemap /usr/bin/makemap
	dodoc FAQ KNOWNBUGS README RELEASE_NOTES doc/op/op.ps

	newdoc sendmail/README README.sendmail
	newdoc sendmail/SECURITY SECURITY
	newdoc sendmail/TUNING TUNING
	newdoc smrsh/README README.smrsh

	newdoc cf/README README.cf
	newdoc cf/cf/README README.install-cf

	cp -pPR cf/* "${D}"/usr/share/sendmail-cf || die "copy failed"

	docinto contrib
	dodoc contrib/*

	insinto /etc/mail

	if use mbox
	then
		newins "${FILESDIR}"/sendmail.mc-r1 sendmail.mc
	else
		newins "${FILESDIR}"/sendmail-procmail.mc sendmail.mc
	fi

	m4 "${D}"/usr/share/sendmail-cf/m4/cf.m4 "${D}"/etc/mail/sendmail.mc \
		> "${D}"/etc/mail/sendmail.cf || die "cf.m4 failed"

	echo "include(\`/usr/share/sendmail-cf/m4/cf.m4')dnl" \
		> "${D}"/etc/mail/submit.mc || die "echo failed"

	cat "${D}"/usr/share/sendmail-cf/cf/submit.mc >> "${D}"/etc/mail/submit.mc || die "submit.mc cat failed"

	echo "# local-host-names - include all aliases for your machine here" \
		> "${D}"/etc/mail/local-host-names || die "local-host-names echo failed"

	cat <<- EOF > "${D}"/etc/mail/trusted-users
		# trusted-users - users that can send mail as others without a warning
		# apache, mailman, majordomo, uucp are good candidates
	EOF

	cat <<- EOF > "${D}"/etc/mail/access
		# Check the /usr/share/doc/sendmail/README.cf file for a description
		# of the format of this file. (search for access_db in that file)
		# The /usr/share/doc/sendmail/README.cf is part of the sendmail-doc
		# package.
		#

	EOF

	cat <<- EOF > "${D}"/etc/conf.d/sendmail
		# Config file for /etc/init.d/sendmail
		# add start-up options here
		SENDMAIL_OPTS="-bd -q30m -L sm-mta" # default daemon mode
		CLIENTMQUEUE_OPTS="-Ac -q30m -L sm-cm" # clientmqueue
		KILL_OPTS="" # add -9/-15/your favorite evil SIG level here

	EOF

	if use sasl; then
		dodir /etc/sasl2
		cat <<- EOF > "${D}"/etc/sasl2/Sendmail.conf
		pwcheck_method: saslauthd
		mech_list: PLAIN LOGIN

		EOF
	fi

	doinitd "${FILESDIR}"/sendmail
	systemd_dounit "${FILESDIR}"/sendmail.service
	systemd_dounit "${FILESDIR}"/sm-client.service
}
