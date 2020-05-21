# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

GENQMAIL_PV=20191010
QMAIL_SPP_PV=0.42

QMAIL_TLS_PV=20200107
QMAIL_TLS_F=notqmail-1.08-tls-${QMAIL_TLS_PV}.patch

QMAIL_BIGTODO_F=notqmail-1.08-big-todo.patch

QMAIL_LARGE_DNS="qmail-103.patch"

inherit qmail

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/notqmail/notqmail.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~hppa ~sparc"
	SRC_URI="https://github.com/notqmail/notqmail/releases/download/${P}/${P}.tar.xz"
fi

DESCRIPTION="qmail -- a secure, reliable, efficient, simple message transfer agent"
HOMEPAGE="
	https://notqmail.org
	https://cr.yp.to/qmail.html
	http://qmail.org
"
SRC_URI="${SRC_URI}
	https://github.com/DerDakon/genqmail/releases/download/genqmail-${GENQMAIL_PV}/${GENQMAIL_F}
	https://www.ckdhr.com/ckd/${QMAIL_LARGE_DNS}
	!vanilla? (
		highvolume? (
			https://github.com/notqmail/notqmail/commit/3a22b45974ddd1230da0dfa21f886c3401bee020.patch -> ${QMAIL_BIGTODO_F}
		)
		qmail-spp? ( mirror://sourceforge/qmail-spp/${QMAIL_SPP_F} )
		https://github.com/notqmail/notqmail/commit/b224a3ceb63ff8ebc57648bf304e079d0bf55023.patch -> ${PN}-1.08-auth.patch
		ssl? (
			https://github.com/notqmail/notqmail/commit/ed58c2eff21612037bbcc633f4b3a8e708f522a0.patch -> ${QMAIL_TLS_F}
		)
	)
"

LICENSE="public-domain"
SLOT="0"
IUSE="authcram gencertdaily highvolume libressl -pop3 qmail-spp ssl test vanilla"
REQUIRED_USE="vanilla? ( !ssl !qmail-spp !highvolume )"
RESTRICT="!test? ( test )"

DEPEND="
	net-dns/libidn2
	net-mail/queue-repair
	sys-apps/gentoo-functions
	sys-apps/groff
	ssl? (
		!libressl? ( >=dev-libs/openssl-1.1:0= )
		libressl? ( dev-libs/libressl:= )
	)
	test? ( dev-libs/check )
"
RDEPEND="${DEPEND}
	acct-group/nofiles
	acct-group/qmail
	acct-user/alias
	acct-user/qmaild
	acct-user/qmaill
	acct-user/qmailp
	acct-user/qmailq
	acct-user/qmailr
	acct-user/qmails
	sys-apps/ucspi-tcp
	virtual/checkpassword
	virtual/daemontools
	authcram? ( >=net-mail/cmd5checkpw-0.30 )
	ssl? (
		pop3? ( sys-apps/ucspi-ssl )
	)
	!mail-mta/courier
	!mail-mta/esmtp
	!mail-mta/exim
	!mail-mta/msmtp[mta]
	!mail-mta/nullmailer
	!mail-mta/opensmtpd
	!mail-mta/postfix
	!mail-mta/qmail-ldap
	!mail-mta/netqmail
	!mail-mta/sendmail
	!mail-mta/ssmtp[mta]
"

src_unpack() {
	genqmail_src_unpack
	use qmail-spp && qmail_spp_src_unpack

	[[ ${PV} == "9999" ]] && git-r3_src_unpack
	[[ ${PV} != "9999" ]] && default
}

PATCHES=(
	"${DISTDIR}/${QMAIL_LARGE_DNS}"
)

src_prepare() {
	if ! use vanilla; then
		if use ssl; then
			PATCHES+=( "${DISTDIR}/${QMAIL_TLS_F}" )
		else
			PATCHES+=( "${DISTDIR}/${P}-auth.patch" )
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

src_test() {
	emake test
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
