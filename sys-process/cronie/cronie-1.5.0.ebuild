# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit cron eutils pam systemd user

DESCRIPTION="Cronie is a standard UNIX daemon cron based on the original vixie-cron"
SRC_URI="https://fedorahosted.org/releases/c/r/cronie/${P}.tar.gz"
HOMEPAGE="https://fedorahosted.org/cronie/wiki"

LICENSE="ISC BSD BSD-2 GPL-2"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 ~s390 sparc x86"
IUSE="anacron +inotify pam selinux"

DEPEND="pam? ( virtual/pam )
	anacron? ( !sys-process/anacron )"
RDEPEND="${DEPEND}"

#cronie supports /etc/crontab
CRON_SYSTEM_CRONTAB="yes"

pkg_setup() {
	enewgroup crontab
}

src_prepare() {
	epatch "${FILESDIR}/cronie-systemd.patch"
}

src_configure() {
	SPOOL_DIR="/var/spool/cron/crontabs" \
	ANACRON_SPOOL_DIR="/var/spool/anacron" \
	econf \
		$(use_with inotify) \
		$(use_with pam) \
		$(use_with selinux) \
		$(use_enable anacron) \
		--enable-syscrontab \
		--with-daemon_username=cron \
		--with-daemon_groupname=cron
}

src_install() {
	emake install DESTDIR="${D}"

	docrondir -m 1730 -o root -g crontab
	fowners root:crontab /usr/bin/crontab
	fperms 2751 /usr/bin/crontab

	insinto /etc/conf.d
	newins "${S}"/crond.sysconfig ${PN}

	insinto /etc
	newins "${FILESDIR}/${PN}-1.3-crontab" crontab
	newins "${FILESDIR}/${PN}-1.2-cron.deny" cron.deny

	keepdir /etc/cron.d
	newinitd "${FILESDIR}/${PN}-1.3-initd" ${PN}
	newpamd "${FILESDIR}/${PN}-1.4.3-pamd" crond

	systemd_newunit contrib/cronie.systemd cronie.service

	if use anacron ; then
		local anacrondir="/var/spool/anacron"
		keepdir ${anacrondir}
		fowners root:cron ${anacrondir}
		fperms 0750 ${anacrondir}

		insinto /etc

		doins contrib/anacrontab

		insinto /etc/cron.hourly
		doins contrib/0anacron
		fperms 0750 /etc/cron.hourly/0anacron
	fi

	dodoc AUTHORS README NEWS contrib/*
}

pkg_postinst() {
	cron_pkg_postinst
}
