# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-process/fcron/fcron-3.1.1.ebuild,v 1.8 2013/02/08 14:54:04 jer Exp $

EAPI=5

WANT_AUTOMAKE=none

inherit cron pam eutils flag-o-matic user autotools

MY_P=${P/_/-}
DESCRIPTION="A command scheduler with extended capabilities over cron and anacron"
HOMEPAGE="http://fcron.free.fr/"
SRC_URI="http://fcron.free.fr/archives/${MY_P}.src.tar.gz"

LICENSE="GPL-2"
KEYWORDS="amd64 arm hppa ia64 ~mips ppc sparc x86 ~x86-fbsd"
IUSE="debug pam selinux linguas_fr +system-crontab readline"

DEPEND="selinux? ( sys-libs/libselinux )
	pam? ( virtual/pam )
	readline? ( sys-libs/readline )"

# see bug 282214 for the reason to depend on bash
RDEPEND="${DEPEND}
	app-shells/bash
	>=app-misc/editor-wrapper-3
	pam? ( >=sys-auth/pambase-20100310 )"

S="${WORKDIR}/${MY_P}"

pkg_setup() {
	enewgroup fcron
	enewuser fcron -1 -1 -1 fcron
	rootuser=$(egetent passwd 0 | cut -d ':' -f 1)
	[[ ${rootuser} ]] || rootuser=root
	rootgroup=$(egetent group 0 | cut -d ':' -f 1)
	[[ ${rootgroup} ]] || rootgroup=root
}

src_prepare() {
	# respect LDFLAGS
	sed -i "s:\(@LIBS@\):\$(LDFLAGS) \1:" Makefile.in || die "sed failed"

	sed -i -e 's:/etc/fcrontab:/etc/fcron/fcrontab:' script/check_system_crontabs.sh || die

	epatch "${FILESDIR}"/${P}-noreadline.patch
	eautoconf
}

src_configure() {
	local myconf

	# Don't try to pass --with-debug as it'll play with cflags as
	# well, and run foreground which is a _very_ nasty idea for
	# Gentoo.
	use debug && append-flags -DDEBUG

	# bindir is used just for calling fcronsighup
	econf \
		--with-cflags="${CFLAGS}" \
		--bindir=/usr/libexec \
		$(use_with pam) \
		$(use_with selinux) \
		$(use_with readline) \
		--without-audit \
		--sysconfdir=/etc/fcron \
		--with-username=fcron \
		--with-groupname=fcron \
		--with-piddir=/var/run \
		--with-spooldir=/var/spool/fcron \
		--with-fifodir=/var/run \
		--with-fcrondyn=yes \
		--disable-checks \
		--with-editor=/usr/libexec/editor \
		--with-sendmail=/usr/sbin/sendmail \
		--with-shell=/bin/sh \
		--without-db2man --without-dsssl-dir \
		--with-rootname=${rootuser} \
		--with-rootgroup=${rootgroup}
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
		doins "${FILESDIR}"/crontab
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

	newinitd "${FILESDIR}"/fcron.init.3 fcron

	dodoc MANIFEST VERSION "${FILESDIR}"/crontab \
		doc/en/txt/{readme,thanks,faq,todo,relnotes,changes}.txt
	newdoc files/fcron.conf fcron.conf.sample
	dohtml doc/en/HTML/*.html
	doman doc/en/man/*.{1,5,8}

	for lang in fr; do
		use linguas_${lang} || continue

		doman -i18n=${lang} doc/${lang}/man/*.{1,5,8} || die
		docinto html/${lang}
		dohtml doc/${lang}/HTML/*.html || die
	done
}

pkg_postinst() {
	elog "If it's the first time you install fcron make sure to execute"
	elog "  emerge --config ${CATEGORY}/${PN}"
	elog "to configure the proper settings."
	if ! use system-crontab; then
		echo ""
		ewarn "Remember that fcron will *not* use /etc/cron.d in this configuration"
		echo ""
	fi
}

pkg_config() {
	if [[ $(fcrontab -l -u systab 2>/dev/null) ]]; then
		eerror "We're not going to make any change to your systab as long as"
		eerror "it contains data; please clear it before proceeding."
		return 1
	fi

	if use system-crontab; then
		elog "This is going to set up fcron to execute check_system_crontabs."
		elog "In this configuration, you're no longer free to edit the systab"
		elog "at your leisure, at it'll be rewritten the moment the crontabs"
		elog "are modified."
		/usr/libexec/check_system_crontabs -v -i -f
	else
		elog "This is going to set up fcron to set up a default systab that"
		elog "executes /etc/cron.{hourly,daily,weekly,monthly}."
		fcrontab -u systab - <<- EOF
		0  *  * * *      rm -f /var/spool/cron/lastrun/cron.hourly
		1  3  * * *      rm -f /var/spool/cron/lastrun/cron.daily
		15 4  * * 6      rm -f /var/spool/cron/lastrun/cron.weekly
		30 5  1 * *      rm -f /var/spool/cron/lastrun/cron.monthly
		EOF
	fi
}
