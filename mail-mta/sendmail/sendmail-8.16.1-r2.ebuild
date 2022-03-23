# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# Note: please bump this together with mail-filter/libmilter

inherit systemd toolchain-funcs

DESCRIPTION="Widely-used Mail Transport Agent (MTA)"
HOMEPAGE="https://www.sendmail.org/"
SRC_URI="ftp://ftp.sendmail.org/pub/${PN}/${PN}.${PV}.tar.gz"

LICENSE="Sendmail GPL-2" # GPL-2 is here for initscript
SLOT="0"
KEYWORDS="~alpha amd64 arm hppa ~ia64 ppc ppc64 ~riscv sparc x86"
IUSE="ipv6 ldap mbox nis sasl sockets ssl tcpd"

BDEPEND="
	sys-devel/m4
	virtual/pkgconfig"
DEPEND="
	acct-group/smmsp
	>=acct-user/smmsp-0-r2
	net-mail/mailbase
	>=sys-libs/db-3.2:=
	ldap? ( net-nds/openldap:= )
	nis? ( net-libs/libnsl:= )
	sasl? ( >=dev-libs/cyrus-sasl-2.1.10 )
	ssl? ( dev-libs/openssl:0= )
	tcpd? ( sys-apps/tcp-wrappers )"
RDEPEND="
	${DEPEND}
	>=mail-filter/libmilter-1.0.2_p1-r1
	!mail-mta/courier
	!mail-mta/esmtp
	!mail-mta/exim
	!mail-mta/mini-qmail
	!mail-mta/msmtp[mta]
	!mail-mta/netqmail
	!mail-mta/nullmailer
	!mail-mta/opensmtpd
	!mail-mta/postfix
	!mail-mta/qmail-ldap
	!>=mail-mta/ssmtp-2.64-r2[mta]
	!net-mail/vacation"
PDEPEND="!mbox? ( mail-filter/procmail )"

src_prepare() {
	eapply "${FILESDIR}"/${PN}-8.16.1-build-system.patch
	eapply -p0 "${FILESDIR}"/${PN}-delivered_hdr.patch
	eapply_user

	local confCCOPTS="${CFLAGS}"
	local confENVDEF="-DMAXDAEMONS=64 -DHAS_GETHOSTBYNAME2=1"
	local confLDOPTS="${LDFLAGS}"
	local confLIBS=
	local confMAPDEF="-DMAP_REGEX"
	local conf_sendmail_LIBS=

	if use ldap; then
		confMAPDEF+=" -DLDAPMAP"
		confLIBS+=" -lldap -llber"
	fi

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
		conf_sendmail_LIBS+=" $($(tc-getPKG_CONFIG) --libs openssl)"
	fi

	if use tcpd; then
		confENVDEF+=" -DTCPWRAPPERS"
		confLIBS+=" -lwrap"
	fi

	use ipv6 && confENVDEF+=" -DNETINET6"
	use nis && confENVDEF+=" -DNIS"
	use sockets && confENVDEF+=" -DSOCKETMAP"

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
	dosym ../sbin/makemap /usr/bin/makemap
	dodoc FAQ KNOWNBUGS README RELEASE_NOTES doc/op/op.ps

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
		newins "${FILESDIR}"/sendmail-procmail.mc sendmail.mc
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
		# Check the /usr/share/doc/sendmail/README.cf file for a description
		# of the format of this file. (search for access_db in that file)
		# The /usr/share/doc/sendmail/README.cf is part of the sendmail-doc
		# package.
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
		cat <<- EOF > "${ED}"/etc/sasl2/Sendmail.conf || die "Sendmail.conf cat ailed"
			pwcheck_method: saslauthd
			mech_list: PLAIN LOGIN

		EOF
	fi

	doinitd "${FILESDIR}"/sendmail
	systemd_dounit "${FILESDIR}"/sendmail.service
	systemd_dounit "${FILESDIR}"/sm-client.service
}
