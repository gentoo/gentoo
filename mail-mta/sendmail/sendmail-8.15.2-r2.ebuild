# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit multilib systemd toolchain-funcs user

DESCRIPTION="Widely-used Mail Transport Agent (MTA)"
HOMEPAGE="http://www.sendmail.org/"
SRC_URI="ftp://ftp.sendmail.org/pub/${PN}/${PN}.${PV}.tar.gz"

LICENSE="Sendmail GPL-2" # GPL-2 is here for initscript
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 ~s390 ~sh sparc x86"
IUSE="ssl ldap libressl sasl tcpd mbox ipv6 nis sockets"

DEPEND="net-mail/mailbase
	sys-devel/m4
	sasl? ( >=dev-libs/cyrus-sasl-2.1.10 )
	tcpd? ( sys-apps/tcp-wrappers )
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:= )
	)
	ldap? ( net-nds/openldap )
	>=sys-libs/db-3.2
	!net-mail/vacation
	"
RDEPEND="${DEPEND}
	>=net-mail/mailbase-0.00
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
	!<mail-mta/ssmtp-2.64-r2
	!>=mail-mta/ssmtp-2.64-r2[mta]"

PDEPEND="!mbox? ( mail-filter/procmail )"

# libmilter library is part of sendmail, but it does not share the version number with it.
# In order to find the right libmilter version number, check SMFI_VERSION definition
# that can be found in ${S}/include/libmilter/mfapi.h (see also SM_LM_VRS_* defines).
# For example, version 1.0.1 has a SMFI_VERSION of 0x01000001.
LIBMILTER_VER=1.0.2

pkg_setup() {
	enewgroup smmsp 209
	enewuser smmsp 209 -1 /var/spool/mqueue smmsp
}

src_prepare() {
	eapply "${FILESDIR}"/"${PN}"-8.14.6-build-system.patch
	eapply -p0 "${FILESDIR}"/sendmail-delivered_hdr.patch
	eapply "${FILESDIR}"/libmilter-sharedlib.patch
	eapply -p0 "${FILESDIR}"/sendmail-starttls-multi-crl.patch
	eapply "${FILESDIR}"/${P}-openssl-1.1.0-fix.patch

	local confCC="$(tc-getCC)"
	local confCCOPTS="${CFLAGS}"
	local confLDOPTS="${LDFLAGS}"
	local confMAPDEF="-DMAP_REGEX"
	local conf_sendmail_LIBS=""
	use sasl && confLIBS="${confLIBS} -lsasl2"  \
		&& confENVDEF="${confENVDEF} -DSASL=2" \
		&& confCCOPTS="${confCCOPTS} -I/usr/include/sasl" \
		&& conf_sendmail_LIBS="${conf_sendmail_LIBS} -lsasl2"
	use tcpd && confENVDEF="${confENVDEF} -DTCPWRAPPERS" \
		&& confLIBS="${confLIBS} -lwrap"
	use ssl && confENVDEF="${confENVDEF} -DSTARTTLS -D_FFR_DEAL_WITH_ERROR_SSL" \
		&& confENVDEF="${confENVDEF} -D_FFR_TLS_1" \
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
		"${FILESDIR}"/site.config.m4 > devtools/Site/site.config.m4
	echo "APPENDDEF(\`confLIBDIRS', \`-L${EROOT}usr/$(get_libdir)')" >> devtools/Site/site.config.m4 || die

	eapply_user
}

src_compile() {
	sh Build AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" || die "compilation failed in main Build script"
	pushd libmilter
	sh Build AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" MILTER_SOVER=${LIBMILTER_VER} || die "libmilter compilation failed"
	popd
}

src_install () {
	local MY_LIBDIR=/usr/$(get_libdir)
	local MY_OBJDIR="obj.`uname -s`.`uname -r`.`uname -m`"
	dodir /usr/bin ${MY_LIBDIR} /usr/include/libmilter
	dodir /usr/share/man/man{1,5,8} /usr/sbin /var/log /usr/share/sendmail-cf
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
			|| die "install failed"
	done
	for dir in rmail mail.local
	do
		make DESTDIR="${D}" LIBDIR="${MY_LIBDIR}" MANROOT=/usr/share/man/man \
			SBINOWN=root SBINGRP=root UBINOWN=root UBINGRP=root \
			MANOWN=root MANGRP=root INCOWN=root INCGRP=root \
			LIBOWN=root LIBGRP=root GBINOWN=root GBINGRP=root \
			MSPQOWN=root CFOWN=root CFGRP=root \
			force-install -C "${MY_OBJDIR}/${dir}" \
			|| die "install failed"
	done

	make DESTDIR="${D}" LIBDIR="${MY_LIBDIR}" MANROOT=/usr/share/man/man \
		SBINOWN=root SBINGRP=root UBINOWN=root UBINGRP=root \
		MANOWN=root MANGRP=root INCOWN=root INCGRP=root \
		LIBOWN=root LIBGRP=root GBINOWN=root GBINGRP=root \
		MSPQOWN=root CFOWN=root CFGRP=root \
		MILTER_SOVER=${LIBMILTER_VER} \
		install -C "${MY_OBJDIR}/libmilter" \
		|| die "install failed"

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
	newdoc libmilter/README README.libmilter

	newdoc cf/README README.cf
	newdoc cf/cf/README README.install-cf
	cp -pPR cf/* "${D}"/usr/share/sendmail-cf

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
		> "${D}"/etc/mail/sendmail.cf
	echo "include(\`/usr/share/sendmail-cf/m4/cf.m4')dnl" \
		> "${D}"/etc/mail/submit.mc
	cat "${D}"/usr/share/sendmail-cf/cf/submit.mc >> "${D}"/etc/mail/submit.mc
	echo "# local-host-names - include all aliases for your machine here" \
		> "${D}"/etc/mail/local-host-names
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

	keepdir /usr/adm/sm.bin
}
