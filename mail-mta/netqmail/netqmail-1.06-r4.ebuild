# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

GENQMAIL_PV=20080406
QMAIL_SPP_PV=0.42

QMAIL_TLS_PV=20070417
QMAIL_TLS_F=${PN}-1.05-tls-smtpauth-${QMAIL_TLS_PV}.patch
QMAIL_TLS_CVE=vu555316.patch

QMAIL_BIGTODO_PV=103
QMAIL_BIGTODO_F=big-todo.${QMAIL_BIGTODO_PV}.patch

QMAIL_LARGE_DNS='qmail-103.patch'

inherit eutils qmail

DESCRIPTION="qmail -- a secure, reliable, efficient, simple message transfer agent"
HOMEPAGE="
	http://netqmail.org
	http://cr.yp.to/qmail.html
	http://qmail.org
"
SRC_URI="mirror://qmail/${P}.tar.gz
	https://dev.gentoo.org/~hollow/distfiles/${GENQMAIL_F}
	http://www.ckdhr.com/ckd/${QMAIL_LARGE_DNS}
	http://inoa.net/qmail-tls/${QMAIL_TLS_CVE}
	!vanilla? (
		highvolume? ( mirror://qmail/${QMAIL_BIGTODO_F} )
		qmail-spp? ( mirror://sourceforge/qmail-spp/${QMAIL_SPP_F} )
		ssl? ( http://shupp.org/patches/${QMAIL_TLS_F} )
	)
"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh ~sparc x86"
IUSE="authcram gencertdaily highvolume libressl qmail-spp ssl vanilla"
REQUIRED_USE='vanilla? ( !ssl !qmail-spp !highvolume )'
RESTRICT="test"

DEPEND="
	!mail-mta/qmail
	net-mail/queue-repair
	ssl? (
		!libressl? ( dev-libs/openssl:0 )
		libressl? ( dev-libs/libressl )
	)
	sys-apps/gentoo-functions
	sys-apps/groff
"
RDEPEND="
	!mail-mta/courier
	!mail-mta/esmtp
	!mail-mta/exim
	!mail-mta/mini-qmail
	!mail-mta/msmtp[mta]
	!mail-mta/nullmailer
	!mail-mta/postfix
	!mail-mta/qmail-ldap
	!mail-mta/sendmail
	!<mail-mta/ssmtp-2.64-r2
	!>=mail-mta/ssmtp-2.64-r2[mta]
	>=sys-apps/ucspi-tcp-0.88-r17
	ssl? ( >=sys-apps/ucspi-ssl-0.70-r1 )
	virtual/daemontools
	>=net-mail/dot-forward-0.71-r3
	virtual/checkpassword
	authcram? ( >=net-mail/cmd5checkpw-0.30 )
	${DEPEND}
"

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

	unpack ${P}.tar.gz
}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-exit.patch
	epatch "${FILESDIR}"/${PV}-readwrite.patch
	epatch "${DISTDIR}"/${QMAIL_LARGE_DNS}
	epatch "${FILESDIR}"/${PV}-fbsd-utmpx.patch

	ht_fix_file Makefile*

	if ! use vanilla; then
		# This patch contains relative paths and needs to be cleaned up.
		sed 's~^--- ../../~--- ~g' \
			<"${DISTDIR}"/${QMAIL_TLS_F} \
			>"${T}"/${QMAIL_TLS_F} || die
		use ssl        && epatch "${T}"/${QMAIL_TLS_F}
		use ssl        && epatch "${DISTDIR}"/${QMAIL_TLS_CVE}
		use highvolume && epatch "${DISTDIR}"/${QMAIL_BIGTODO_F}

		if use qmail-spp; then
			if use ssl; then
				epatch "${QMAIL_SPP_S}"/qmail-spp-smtpauth-tls-20060105.diff
			else
				epatch "${QMAIL_SPP_S}"/netqmail-spp.diff
			fi
			cd "${WORKDIR}" || die
			epatch "${FILESDIR}"/genqmail-20080406-ldflags.patch
			cd - || die
		fi
	fi

	cd "${WORKDIR}" || die
	epatch "${FILESDIR}"/use-new-path-for-functions.sh.patch
	cd - || die

	qmail_src_postunpack

	# Fix bug #33818 but for netqmail (Bug 137015)
	if ! use authcram; then
		einfo "Disabled CRAM_MD5 support"
		sed -e 's,^#define CRAM_MD5$,/*&*/,' -i "${S}"/qmail-smtpd.c || die
	else
		einfo "Enabled CRAM_MD5 support"
	fi
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
