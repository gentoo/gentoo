# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

WANT_AUTOMAKE=none

inherit cron pam flag-o-matic user autotools versionator systemd

DESCRIPTION="A command scheduler with extended capabilities over cron and anacron"
HOMEPAGE="http://fcron.free.fr/"
SRC_URI="http://fcron.free.fr/archives/${P}.src.tar.gz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
IUSE="audit debug pam selinux l10n_fr +mta +system-crontab readline"

DEPEND="audit? ( sys-process/audit )
	pam? ( virtual/pam )
	readline? ( sys-libs/readline:= )
	selinux? ( sys-libs/libselinux )"

RDEPEND="${DEPEND}
	app-misc/editor-wrapper
	mta? ( virtual/mta )
	pam? ( sys-auth/pambase )"

PATCHES=(
	"${FILESDIR}"/${PN}-3.1.1-noreadline.patch
	"${FILESDIR}"/${PN}-3.2.1-configure-fix-audit-parameter-check.patch
	"${FILESDIR}"/${PN}-3.2.1-musl-getopt-order.patch
)

pkg_setup() {
	enewgroup fcron
	enewuser fcron -1 -1 -1 fcron
	rootuser=$(egetent passwd 0 | cut -d ':' -f 1)
	[[ ${rootuser} ]] || rootuser=root
	rootgroup=$(egetent group 0 | cut -d ':' -f 1)
	[[ ${rootgroup} ]] || rootgroup=root
}

src_prepare() {
	default

	# respect LDFLAGS
	sed -i "s:\(@LIBS@\):\$(LDFLAGS) \1:" Makefile.in || die "sed failed"

	# Adjust fcrontab path
	sed -i -e 's:/etc/fcrontab:/etc/fcron/fcrontab:' script/check_system_crontabs.sh || die

	mv configure.in configure.ac || die

	cp "${FILESDIR}"/crontab.2 "${WORKDIR}"/crontab || die

	eautoconf
}

src_configure() {
	# Don't try to pass --with-debug as it'll play with cflags as
	# well, and run foreground which is a _very_ nasty idea for
	# Gentoo.
	use debug && append-cppflags -DDEBUG

	# bindir is used just for calling fcronsighup
	econf \
		--with-cflags="${CFLAGS}" \
		--bindir=/usr/libexec \
		--sbindir=/usr/libexec \
		$(use_with audit) \
		$(use_with mta sendmail) \
		$(use_with pam) \
		$(use_with readline) \
		$(use_with selinux) \
		--sysconfdir=/etc/fcron \
		--with-username=fcron \
		--with-groupname=fcron \
		--with-piddir=/run \
		--with-spooldir=/var/spool/fcron \
		--with-fifodir=/run \
		--with-fcrondyn=yes \
		--disable-checks \
		--with-editor=/usr/libexec/editor \
		--with-shell=/bin/sh \
		--without-db2man \
		--without-dsssl-dir \
		--with-rootname=${rootuser} \
		--with-rootgroup=${rootgroup} \
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
}

src_compile() {
	default

	# bug #216460
	sed -i \
		-e 's:/usr/local/etc/fcron:/etc/fcron/fcron:g' \
		-e 's:/usr/local/etc:/etc:g' \
		-e 's:/usr/local/:/usr/:g' \
		doc/*/*/*.{txt,1,5,8,html} \
		|| die "unable to fix documentation references"
}

src_install() {
	keepdir /var/spool/fcron

	exeinto /usr/libexec
	doexe fcron fcronsighup

	dobin fcrondyn fcrontab

	insinto /etc/fcron
	doins files/fcron.{allow,deny,conf}

	if use system-crontab; then
		dosym fcrontab /usr/bin/crontab

		exeinto /usr/libexec
		newexe script/check_system_crontabs.sh check_system_crontabs

		insinto /etc/fcron
		newins "${FILESDIR}"/fcrontab.2 fcrontab

		fowners ${rootuser}:fcron /etc/fcron/fcrontab
		fperms 0640 /etc/fcron/fcrontab

		insinto /etc
		newins "${FILESDIR}"/crontab.2 crontab
	fi

	fowners fcron:fcron \
		/var/spool/fcron \
		/usr/bin/fcron{dyn,tab}

	# fcronsighup needs to be suid root, because it sends a HUP to the
	# running fcron daemon, but only has to be called by the fcron group
	# anyway
	fowners ${rootuser}:fcron \
		/usr/libexec/fcronsighup \
		/etc/fcron/fcron.{allow,deny,conf} \
		/etc/fcron

	fperms 6770 /var/spool/fcron
	fperms 6775 /usr/bin/fcron{dyn,tab}

	fperms 4710 /usr/libexec/fcronsighup

	fperms 0750 /etc/fcron
	fperms 0640 /etc/fcron/fcron.{allow,deny,conf}

	pamd_mimic system-services fcron auth account session
	cat > "${T}"/fcrontab.pam <<- EOF
	# Don't ask for the user's password; fcrontab will only allow to
	# change user if running as root.
	auth		sufficient		pam_permit.so

	# Still use the system-auth stack for account and session as the
	# sysadmin might have set up stuff properly, and also avoids
	# sidestepping limits (since fcrontab will run \$EDITOR).
	account		include			system-auth
	session		include			system-auth
	EOF
	newpamd "${T}"/fcrontab.pam fcrontab

	newinitd "${FILESDIR}"/fcron.init-r5 fcron
	systemd_newunit "${S}/script/fcron.init.systemd" fcron.service

	newconfd "${FILESDIR}"/fcron.confd fcron

	local DOCS=( MANIFEST VERSION "${WORKDIR}/crontab")
	DOCS+=( doc/en/txt/{readme,thanks,faq,todo,relnotes,changes}.txt )

	local HTML_DOCS=( doc/en/HTML/. )

	einstalldocs

	newdoc files/fcron.conf fcron.conf.sample
	doman doc/en/man/*.{1,5,8}

	for lang in fr; do
		use l10n_${lang} || continue

		doman -i18n=${lang} doc/${lang}/man/*.{1,5,8}

		docinto html/${lang}
		dodoc -r doc/${lang}/HTML/.
	done
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation
		elog "Make sure you execute"
		elog ""
		elog "  # emerge --config ${CATEGORY}/${PN}"
		elog ""
		elog "to install the default systab on this system."
	else
		local v
		for v in ${REPLACING_VERSIONS}; do
			if ! version_is_at_least "3.2.1" ${v}; then
				# This is an upgrade

				elog "fcron's default systab was updated since your last installation."
				elog "You can use"
				elog ""
				elog "  # emerge --config ${CATEGORY}/${PN}"
				elog ""
				elog "to re-install systab (do not call this command before you"
				elog "have merged your configuration files)."

				# Show this elog only once
				break
			fi
		done
	fi

	if ! use system-crontab; then
		echo ""
		ewarn "Remember that fcron will *not* use /etc/cron.d in this configuration"
		ewarn "due to USE=-system-crontab!"
		echo ""
	fi
}

pkg_config() {
	if [[ $(fcrontab -l -u systab 2>/dev/null) ]]; then
		eerror "We're not going to make any change to your systab as long as"
		eerror "it contains data; please clear it before proceeding."
		eerror "You can do that with"
		eerror ""
		eerror "  # fcrontab -u systab -r"
		eerror ""
		eerror "However you are advised to do this by hand to review existing"
		eerror "systab just in case."
		return 1
	fi

	if use system-crontab; then
		elog "This is going to set up fcron to execute check_system_crontabs."
		elog "In this configuration, /etc/crontab and /etc/cron.d are respected."
		elog "Per default fcron will check for modifications every 10 minutes."
		/usr/libexec/check_system_crontabs -v -i -f
	else
		elog "This is going to set up fcron to set up a default systab that"
		elog "executes /etc/cron.{hourly,daily,weekly,monthly} but will ignore"
		elog "/etc/crontab and /etc/cron.d."
		fcrontab -u systab - <<- EOF
		!serial(true)
		00   *    *    *    *     /bin/rm -f /var/spool/cron/lastrun/cron.hourly
		00   00   *    *    *     /bin/rm -f /var/spool/cron/lastrun/cron.daily
		00   00   *    *    6     /bin/rm -f /var/spool/cron/lastrun/cron.weekly
		00   00   1    *    *     /bin/rm -f /var/spool/cron/lastrun/cron.monthly
		*/10 *    *    *    *     /usr/bin/test -x /usr/sbin/run-crons && /usr/sbin/run-crons
		!serial(false)
		EOF
	fi
}
