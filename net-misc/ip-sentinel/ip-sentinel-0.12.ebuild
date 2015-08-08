# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils user

DESCRIPTION="Prevent unauthorized usage of IPs in the local ethernet broadcastdomain by answering ARP-requests"
HOMEPAGE="http://www.nongnu.org/ip-sentinel/"
LICENSE="GPL-2"
SRC_URI="http://savannah.nongnu.org/download/ip-sentinel/${P}.tar.bz2"
SLOT="0"
KEYWORDS="x86"

DOCS=( AUTHORS ChangeLog NEWS README THANKS )

src_install() {
	default

	newinitd "${FILESDIR}"/ip-sentinel.init ip-sentinel
	newconfd "${FILESDIR}"/ip-sentinel.conf.d ip-sentinel

	insinto /etc
	newins "${FILESDIR}"/ip-sentinel.cfg ip-sentinel.cfg
}

pkg_setup() {
	enewgroup ipsentinel
	enewuser ipsentinel -1 -1 -1 ipsentinel
}

pkg_postinst() {
	elog "You can edit /etc/conf.d/ip-sentinel to customize startup daemon"
	elog "settings."
	elog
	elog "Default ip-sentinel config is in /etc/ip-sentinel.cfg"
	elog
	elog "The ip-sentinel ebuild has chroot support."
	elog "If you like to run ip-sentinel in chroot AND this is a new install OR"
	elog "your ip-sentinel doesn't already run in chroot, simply run:"
	elog "emerge --config =${CATEGORY}/${PF}"
	elog "Before running the above command you might want to change the chroot"
	elog "dir in /etc/conf.d/ip-sentinel, otherwise /chroot/ip-sentinel will be used."
	echo
	ewarn "And please! DO NOT START THIS DAEMON thoughtlessly."
	ewarn "If you DO this will BLOCK ALL communication inside your ethernet"
	ewarn "segment!!! If you have any doubts do not start ip-sentinel."
}

pkg_config() {
	CHROOT=`sed -n 's/^[[:blank:]]\?CHROOT="\([^"]\+\)"/\1/p' /etc/conf.d/ip-sentinel 2>/dev/null`

	if [ ! -d "${CHROOT:=/chroot/ip-sentinel}" ] ; then
		ebegin "Setting up the chroot directory"
			mkdir -m 0755 -p "${CHROOT}/etc"
			cp -R /etc/ip-sentinel.cfg "${CHROOT}/etc"
		eend

		if [ "`grep '^#[[:blank:]]\?CHROOT' /etc/conf.d/ip-sentinel`" ] ; then
			sed -e '/^#[[:blank:]]\?CHROOT/s/^#[[:blank:]]\?//' \
				-i /etc/conf.d/ip-sentinel
		fi
	else
		eerror
		eerror "${CHROOT} already exists. Quitting."
		eerror
	fi
}
