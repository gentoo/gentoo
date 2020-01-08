# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools git-r3 udev

DESCRIPTION="Simple udev-based automounter for removable USB media"
HOMEPAGE="https://github.com/mgorny/uam/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/mgorny/uam.git"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	acct-group/plugdev
	virtual/udev"
DEPEND="virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

pkg_postinst() {
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
