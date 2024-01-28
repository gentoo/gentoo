# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GENQMAIL_PV=20200817
QMAIL_SPP_PV=0.42

QMAIL_TLS_PV=20190114
QMAIL_TLS_F=${PN}-1.05-tls-smtpauth-${QMAIL_TLS_PV}.patch
QMAIL_TLS_CVE=vu555316.patch

QMAIL_BIGTODO_F=big-todo.103.patch

QMAIL_LARGE_DNS='qmail-103.patch'

QMAIL_SMTPUTF8='qmail-smtputf8.patch'

inherit qmail

DESCRIPTION="qmail -- a secure, reliable, efficient, simple message transfer agent"
HOMEPAGE="
	http://netqmail.org
	https://cr.yp.to/qmail.html
	http://qmail.org
"
SRC_URI="http://qmail.org/${P}.tar.gz
	https://github.com/DerDakon/genqmail/releases/download/genqmail-${GENQMAIL_PV}/${GENQMAIL_F}
	https://www.ckdhr.com/ckd/${QMAIL_LARGE_DNS}
	!vanilla? (
		highvolume? ( http://qmail.org/${QMAIL_BIGTODO_F} )
		qmail-spp? ( mirror://sourceforge/qmail-spp/${QMAIL_SPP_F} )
		ssl? (
			https://mirror.alexh.name/qmail/netqmail/${QMAIL_TLS_F}
			http://inoa.net/qmail-tls/${QMAIL_TLS_CVE}
			https://arnt.gulbrandsen.priv.no/qmail/qmail-smtputf8.patch
		)
	)
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~hppa ~ia64 ~mips ppc64 ~s390 sparc x86"
IUSE="authcram gencertdaily highvolume pop3 qmail-spp ssl vanilla"
REQUIRED_USE="vanilla? ( !ssl !qmail-spp !highvolume )"
RESTRICT="test"

DEPEND="
	acct-group/nofiles
	acct-group/qmail
	acct-user/alias
	acct-user/qmaild
	acct-user/qmaill
	acct-user/qmailp
	acct-user/qmailq
	acct-user/qmailr
	acct-user/qmails
	net-dns/libidn2
	net-mail/queue-repair
	sys-apps/gentoo-functions
	sys-apps/groff
	ssl? ( >=dev-libs/openssl-1.1:0= )
"
RDEPEND="${DEPEND}
	sys-apps/ucspi-tcp
	virtual/checkpassword
	virtual/daemontools
	authcram? ( >=net-mail/cmd5checkpw-0.30 )
	!mail-mta/courier
	!mail-mta/esmtp
	!mail-mta/exim
	!mail-mta/mini-qmail
	!mail-mta/msmtp[mta]
	!mail-mta/nullmailer
	!mail-mta/opensmtpd
	!mail-mta/postfix
	!mail-mta/qmail-ldap
	!mail-mta/sendmail
	!mail-mta/ssmtp[mta]
"

src_unpack() {
	genqmail_src_unpack
	use qmail-spp && qmail_spp_src_unpack

	unpack ${P}.tar.gz
}

PATCHES=(
	"${FILESDIR}/${PV}-exit.patch"
	"${FILESDIR}/${PV}-readwrite.patch"
	"${DISTDIR}/${QMAIL_LARGE_DNS}"
	"${FILESDIR}/${PV}-fbsd-utmpx.patch"
	"${FILESDIR}/${P}-ipme-multiple.patch"
	"${FILESDIR}/${P}-any-to-cname.patch"
	"${FILESDIR}/${P}-CVE-2005-1513.patch"
	"${FILESDIR}/${P}-CVE-2005-1514.patch"
	"${FILESDIR}/${P}-CVE-2005-1515.patch"
	"${FILESDIR}/${P}-overflows.patch"
)

src_prepare() {
	if ! use vanilla; then
		if use ssl; then
			# This patch contains relative paths and needs to be cleaned up.
			sed 's~^--- \.\./\.\./~--- ~g' \
				< "${DISTDIR}"/${QMAIL_TLS_F} \
				> "${T}"/${QMAIL_TLS_F} || die
			PATCHES+=( "${T}/${QMAIL_TLS_F}"
				"${DISTDIR}/${QMAIL_TLS_CVE}"
				"${FILESDIR}/qmail-smtputf8.patch"
				"${FILESDIR}/qmail-smtputf8-crlf-fix.patch"
			)
		fi
		if use highvolume; then
			PATCHES+=( "${DISTDIR}/${QMAIL_BIGTODO_F}" )
		fi

		if use qmail-spp; then
			if use ssl; then
				SPP_PATCH="${QMAIL_SPP_S}/qmail-spp-smtpauth-tls-20060105.diff"
			else
				SPP_PATCH="${QMAIL_SPP_S}/netqmail-spp.diff"
			fi
			# make the patch work with "-p1"
			sed -e 's#^--- \([Mq]\)#--- a/\1#' -e 's#^+++ \([Mq]\)#+++ b/\1#' -i ${SPP_PATCH} || die

			PATCHES+=( "${SPP_PATCH}" )
		fi
	fi

	default

	qmail_src_postunpack

	# Fix bug #33818 but for netqmail (Bug 137015)
	if ! use authcram; then
		einfo "Disabled CRAM_MD5 support"
		sed -e 's,^#define CRAM_MD5$,/*&*/,' -i "${S}"/qmail-smtpd.c || die
	else
		einfo "Enabled CRAM_MD5 support"
	fi

	ht_fix_file Makefile*
}

src_compile() {
	qmail_src_compile
	use qmail-spp && qmail_spp_src_compile
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
	elog "https://wiki.gentoo.org/wiki/Virtual_mail_hosting_with_qmail"
	elog "  -- qmail/vpopmail Virtual Mail Hosting System Guide"
	elog "http://www.lifewithqmail.com/"
	elog "  -- Life with qmail"
	elog
}

pkg_config() {
	# avoid some weird locale problems
	export LC_ALL=C

	qmail_config_fast
	qmail_tcprules_config
	qmail_tcprules_build

	use ssl && qmail_ssl_generate
}
