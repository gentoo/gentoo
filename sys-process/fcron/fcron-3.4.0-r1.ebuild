# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WANT_AUTOMAKE="none"

inherit autotools cron eapi9-ver flag-o-matic pam systemd user-info

MY_PV="${PV/_beta/}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A command scheduler with extended capabilities over cron and anacron"
HOMEPAGE="http://fcron.free.fr/"
SRC_URI="http://fcron.free.fr/archives/${MY_P}.src.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="audit debug pam selinux +mta +system-crontab readline"

DEPEND="
	acct-group/fcron
	acct-user/fcron
	virtual/libcrypt:=
	audit? ( sys-process/audit )
	pam? ( sys-libs/pam )
	readline? ( sys-libs/readline:= )
	selinux? ( sys-libs/libselinux )
"

RDEPEND="
	${DEPEND}
	app-misc/editor-wrapper
	mta? ( virtual/mta )
	pam? ( sys-auth/pambase )
"

PATCHES=(
	"${FILESDIR}"/fcron-3.1.1-noreadline.patch
	"${FILESDIR}"/fcron-3.2.1-musl-getopt-order.patch
	"${FILESDIR}"/fcron-3.4.0-order.patch
	"${FILESDIR}"/fcron-3.4.0-docdir.patch
)

pkg_setup() {
	rootuser=$(egetent passwd 0 | cut -d ':' -f 1)
	[[ ${rootuser} ]] || rootuser=root
	rootgroup=$(egetent group 0 | cut -d ':' -f 1)
	[[ ${rootgroup} ]] || rootgroup=root
}

src_prepare() {
	default

	# respect LDFLAGS
	sed "s:\(@LIBS@\):\$(LDFLAGS) \1:" -i Makefile.in || die "sed failed"

	# Adjust fcrontab path
	sed -e 's:/etc/fcrontab:/etc/fcron/fcrontab:' -i script/check_system_crontabs.sh || die

	mv configure.in configure.ac || die

	# For docs
	cp "${FILESDIR}"/crontab.2 "${WORKDIR}"/crontab || die

	sed -e '/systemctl daemon-reload/d' -i Makefile.in || die
	# These two cause installation of /run
	sed -e '/PIDDIR/d' -i Makefile.in || die
	sed -e '/FIFODIR/d' -i Makefile.in || die

	# Workaround for:
	#  * QA Notice: system executables owned by nonzero uid:
	# But fcron by design doesn't suid root. Hence, hide that fact
	# from the QA check via a wrapper (not a symlink)
	# https://bugs.gentoo.org/925512
	for file in fcrontab fcrondyn; do
		cat > "${file}_wrapper" <<-EOF
		#!/bin/sh
		exec "${EPREFIX}/usr/libexec/${file}" "\$@"
		EOF
	done

	eautoconf
}

src_configure() {
	# Don't try to pass --with-debug as it'll play with cflags as
	# well, and run foreground which is a _very_ nasty idea for
	# Gentoo.
	use debug && append-cppflags -DDEBUG

	# bindir is used just for calling fcronsighup
	local myeconfargs=(
		--with-cflags="${CFLAGS}"
		--bindir=/usr/libexec
		--sbindir=/usr/libexec
		$(use_with audit)
		$(use_with mta sendmail)
		$(use_with pam)
		$(use_with readline)
		$(use_with selinux)
		--sysconfdir=/etc/fcron
		--with-username=fcron
		--with-groupname=fcron
		--with-piddir=/run
		--with-spooldir=/var/spool/fcron
		--with-fifodir=/run
		--with-fcrondyn=yes
		--disable-checks
		--with-editor=/usr/libexec/editor
		--with-shell=/bin/sh
		--without-db2man
		--without-dsssl-dir
		--with-rootname=${rootuser}
		--with-rootgroup=${rootgroup}
		--with-systemdsystemunitdir="$(systemd_get_systemunitdir)"
	)

	econf "${myeconfargs[@]}"
}

src_compile() {
	default

	# bug #216460
	sed \
		-e 's:/usr/local/etc/fcron:/etc/fcron/fcron:g' \
		-e 's:/usr/local/etc:/etc:g' \
		-e 's:/usr/local/:/usr/:g' \
		-i doc/*/*/*.{txt,1,5,8,html} \
		|| die "unable to fix documentation references"
}

src_install() {
	emake install BOOTINSTALL=0 DESTDIR="${ED}" STRIP=echo

	keepdir /var/spool/fcron
	fowners fcron:fcron /var/spool/fcron
	fperms 6770 /var/spool/fcron

	newbin fcrontab_wrapper fcrontab
	newbin fcrondyn_wrapper fcrondyn

	# bitstring.h is a private header inside fcron, not even installed.
	find "${ED}/usr/share/man" -name '*bitstring*' -delete || die

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

	if use pam ; then
		rm "${ED}/etc/fcron/pam.conf" || die
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
	fi

	newinitd "${FILESDIR}"/fcron.init-r5 fcron
	newconfd "${FILESDIR}"/fcron.confd fcron

	local DOCS=( "${WORKDIR}/crontab" )
	einstalldocs
}

pkg_postinst() {
	if [[ -z "${REPLACING_VERSIONS}" ]]; then
		# This is a new installation
		elog "Make sure you execute"
		elog ""
		elog "  # emerge --config ${CATEGORY}/${PN}"
		elog ""
		elog "to install the default systab on this system."
	elif ver_replacing -lt "3.2.1"; then
		# This is an upgrade
		elog "fcron's default systab was updated since your last installation."
		elog "You can use"
		elog ""
		elog "  # emerge --config ${CATEGORY}/${PN}"
		elog ""
		elog "to re-install systab (do not call this command before you"
		elog "have merged your configuration files)."
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
