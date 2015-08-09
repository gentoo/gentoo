# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

GENQMAIL_PV=20080406
QMAIL_SPP_PV=0.42

QMAIL_LDAP_PV=20060201
QMAIL_LDAP_F=${P}-${QMAIL_LDAP_PV}.patch.gz

QMAIL_LDAP_SPP_F=${P}-spp-${QMAIL_SPP_PV}.patch

QMAIL_LDAP_CONTROLS_PV=20060401d
QMAIL_LDAP_CONTROLS_F=${P}-${QMAIL_LDAP_PV}-controls${QMAIL_LDAP_CONTROLS_PV}.patch

inherit eutils qmail

DESCRIPTION="qmail -- a secure, reliable, efficient, simple message transfer agent"
HOMEPAGE="
	http://www.qmail-ldap.org
	http://cr.yp.to/qmail.html
	http://qmail.org
"
SRC_URI="mirror://qmail/qmail-${PV}.tar.gz
	http://dev.gentoo.org/~hollow/distfiles/${GENQMAIL_F}
	http://www.nrg4u.com/qmail/${QMAIL_LDAP_F}
	mirror://gentoo/${QMAIL_LDAP_CONTROLS_F}
	mirror://gentoo/${P}-queue-custom-error.patch
	!vanilla? (
		qmail-spp? (
			mirror://sourceforge/qmail-spp/${QMAIL_SPP_F}
			mirror://gentoo/${QMAIL_LDAP_SPP_F}
		)
	)
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="cluster debug gencertdaily highvolume qmail-spp rfc2307 rfc822 ssl vanilla zlib"
RESTRICT="test"

DEPEND="
	!mail-mta/qmail
	net-nds/openldap
	net-mail/queue-repair
	ssl? ( dev-libs/openssl )
"
RDEPEND="
	!mail-mta/courier
	!mail-mta/esmtp
	!mail-mta/exim
	!mail-mta/mini-qmail
	!mail-mta/msmtp
	!mail-mta/netqmail
	!mail-mta/nullmailer
	!mail-mta/postfix
	!mail-mta/sendmail
	!mail-mta/opensmtpd
	!mail-mta/ssmtp
	>=sys-apps/ucspi-tcp-0.88-r17
	ssl? ( >=sys-apps/ucspi-ssl-0.70-r1 )
	virtual/daemontools
	>=net-mail/dot-forward-0.71-r3
	${DEPEND}
"

S="${WORKDIR}"/qmail-${PV}

pkg_setup() {
	if [[ -n "${QMAIL_PATCH_DIR}" ]]; then
		eerror
		eerror "The QMAIL_PATCH_DIR variable for custom patches"
		eerror "has been removed from ${PN}. If you need custom patches"
		eerror "you should create a copy of this ebuild in an overlay."
		eerror
		die "QMAIL_PATCH_DIR is not supported anymore"
	fi

	qmail_create_users
}

src_unpack() {
	genqmail_src_unpack
	use qmail-spp && qmail_spp_src_unpack

	unpack qmail-${PV}.tar.gz

	cd "${S}"

	# main ldap patch
	# includes: netqmail-1.05, EXTTODO, BIGTODO, TLS/SMTPAUTH, 0.0.0.0 fix
	epatch "${DISTDIR}"/${QMAIL_LDAP_F}

	# QmailLDAP/Controls patch
	# includes: RFC2307/822 fixes
	epatch "${DISTDIR}"/${QMAIL_LDAP_CONTROLS_F}
	epatch "${FILESDIR}"/${PV}-warnings.patch

	# fix libraries for controls patch
	sed -i -e 's|NEWLDAPPROGLIBS=.*|& str.a|' Makefile

	ht_fix_file Makefile*

	if ! use vanilla; then
		# Add custom bounce messages to qmail-queue
		epatch "${DISTDIR}"/${P}-queue-custom-error.patch

		# qmail-spp patch
		use qmail-spp && epatch "${DISTDIR}"/${QMAIL_LDAP_SPP_F}
	fi

	# makefile options
	local INCLUDES="-I/usr/include"
	local LDAPLIBS="-L/usr/lib -lldap -llber"
	local LDAPFLAGS="-DALTQUEUE -DEXTERNAL_TODO -DDASH_EXT -DSMTPEXECCHECK"
	local CONTROLDB="-DUSE_CONTROLDB -DQLDAP_BAILOUT"
	local SECUREBIND= RFCFLAGS=

	use cluster    && LDAPFLAGS="${LDAPFLAGS} -DQLDAP_CLUSTER"
	use highvolume && LDAPFLAGS="${LDAPFLAGS} -DBIGTODO"
	use zlib       && LDAPFLAGS="${LDAPFLAGS} -DDATA_COMPRESS -D QMQP_COMPRESS"

	use rfc2307    && RFCFLAGS="${RFCFLAGS} -DUSE_RFC2307"
	use rfc822     && RFCFLAGS="${RFCFLAGS} -DUSE_RFC822"

	use ssl        && SECUREBIND="-DSECUREBIND_TLS -DSECUREBIND_SSL"

	# a lot of sed magic to get Makefile right
	local EXP=

	EXP="${EXP} s|^#LDAPINCLUDES=.*|LDAPINCLUDES=${INCLUDES}|;"
	EXP="${EXP} s|^#LDAPLIBS=.*|LDAPLIBS=${LDAPLIBS}|;"
	EXP="${EXP} s|^#LDAPFLAGS=.*|LDAPFLAGS=${LDAPFLAGS}|;"

	EXP="${EXP} s|^#CONTROLDB=.*|CONTROLDB=${CONTROLDB}|;"
	EXP="${EXP} s|^#RFCFLAGS=.*|RFCFLAGS=${RFCFLAGS}|;"
	EXP="${EXP} s|^#SECUREBIND=.*|SECUREBIND=${SECUREBIND}|;"

	# TODO: do we even need this with LDAP?
	EXP="${EXP} s|^#SHADOWLIBS=.*|SHADOWLIBS=-lcrypt|;"

	# automagic maildir creation
	EXP="${EXP} s|^#\(MDIRMAKE=.*\)|\1|;"
	EXP="${EXP} s|^#\(HDIRMAKE=.*\)|\1|;"

	use debug && EXP="${EXP} s|^#\(DEBUG=.*\)|\1|;"
	use zlib  && EXP="${EXP} s|^#ZLIB=.*|ZLIB=-lz|;"

	if use ssl; then
		EXP="${EXP} s|^#\(TLS=.*\)|\1|;"
		EXP="${EXP} s|^#TLSINCLUDES=.*|TLSINCLUDES=${INCLUDES}|;"
		EXP="${EXP} s|^#TLSLIBS=.*|TLSLIBS=-L/usr/lib -lssl -lcrypto|;"
		EXP="${EXP} s|^#OPENSSLBIN=.*|OPENSSLBIN=/usr/bin/openssl|;"
	fi

	qmail_src_postunpack

	sed -i -e "${EXP}" Makefile || die "could not patch Makefile"
}

src_compile() {
	qmail_src_compile ldap
	use qmail-spp && qmail_spp_src_compile
}

qmail_full_install_hook() {
	insinto ${QMAIL_HOME}/bin
	insopts -o root -g qmail -m 0755
	doins auth_smtp condwrite digest dirmaker pbs{add,check,dbd} \
		qmail-{forward,group,quotawarn,reply,secretary,verify}

	insopts -o root -g root -m 0750
	doins qmail-ldaplookup

	insopts -o root -g qmail -m 0711
	doins qmail-todo

	insopts -o root -g qmail -m 0700
	doins auth_{imap,pop} qmail-cdb
}

qmail_man_install_hook() {
	dodoc EXTTODO POPBEFORESMTP QLDAP* "${FILESDIR}"/samples.ldif
}

qmail_config_install_hook() {
	einfo "Installing OpenLDAP schema"
	insinto /etc/openldap/schema
	doins qmail.schema qmail-ldap-control/qmailControl.schema
}

src_install() {
	qmail_src_install
}

pkg_postinst() {
	qmail_queue_setup
	qmail_rootmail_fixup
	qmail_tcprules_build

	qmail_config_notice
	qmail_supervise_config_notice
	elog
	elog "If you are looking for documentation, check those links:"
	elog "http://www.lifewithqmail.com/ldap/"
	elog "  -- Life with qmail-ldap"
	elog
	elog "For sample ldifs, please check /usr/share/doc/${PF}/"
	elog
}

pkg_preinst() {
	qmail_tcprules_fixup
}

pkg_config() {
	# avoid some weird locale problems
	export LC_ALL=C

	qmail_config_fast
	qmail_tcprules_config
	qmail_tcprules_build

	use ssl && qmail_ssl_generate
}
