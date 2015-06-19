# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/uam/uam-9999.ebuild,v 1.4 2014/07/06 13:22:22 mgorny Exp $

EAPI=5

#if LIVE
AUTOTOOLS_AUTORECONF=yes
EGIT_REPO_URI="http://bitbucket.org/mgorny/${PN}.git"

inherit git-r3
#endif

inherit autotools-utils udev user

DESCRIPTION="Simple udev-based automounter for removable USB media"
HOMEPAGE="https://bitbucket.org/mgorny/uam/"
SRC_URI="https://www.bitbucket.org/mgorny/${PN}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="virtual/udev"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

#if LIVE
KEYWORDS=
SRC_URI=
#endif

pkg_postinst() {
	# The plugdev group is created by pam, pmount and many other ebuilds
	# in gx86. As we don't want to depend on any of them (even pmount is
	# optional), we create it ourself too.
	enewgroup plugdev

	elog "To be able to access uam-mounted filesystems, you have to be"
	elog "a member of the 'plugdev' group."
	elog
	elog "Note that uam doesn't provide any way to allow unprivileged user"
	elog "to manually umount devices. The upstream suggested solution"
	elog "is to use [sys-apps/pmount]. If you don't feel like installing"
	elog "additional tools, remember to sync before removing your USB stick."
	elog
	elog "If you'd like uam to mount ejectable media like CDs/DVDs, you need"
	elog "to enable in-kernel media polling, e.g.:"
	elog "	echo 5000 > /sys/module/block/parameters/events_dfl_poll_msecs"
	elog "where 5000 would mean a poll will occur every 5 seconds."
	elog
	elog "If you'd like to receive libnotify-based notifications, you need"
	elog "to install the [x11-misc/sw-notify-send] tool."

	udev_reload
}
