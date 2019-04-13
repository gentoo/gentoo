# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gnome2-utils linux-info xdg-utils

DESCRIPTION="A multi-panel tabbed file manager"
HOMEPAGE="https://ignorantguru.github.com/spacefm/"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/IgnorantGuru/${PN}.git"
	EGIT_BRANCH="next"
	inherit git-r3
else
	KEYWORDS="amd64 x86"
	SRC_URI="https://github.com/IgnorantGuru/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
IUSE="gtk2 +gtk3 +startup-notification +video-thumbnails"

RDEPEND="dev-libs/glib:2
	dev-util/desktop-file-utils
	>=virtual/udev-143
	virtual/freedesktop-icon-theme
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/pango
	x11-libs/libX11
	x11-misc/shared-mime-info
	gtk2? ( gtk3? ( x11-libs/gtk+:3 ) !gtk3? ( x11-libs/gtk+:2 ) )
	!gtk2? ( x11-libs/gtk+:3 )
	startup-notification? ( x11-libs/startup-notification )
	video-thumbnails? ( media-video/ffmpegthumbnailer )"
DEPEND="${RDEPEND}
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/${PN}-9999-include-sysmacros.patch )

src_configure() {
	econf \
		--htmldir=/usr/share/doc/${PF}/html \
		$(use_enable startup-notification) \
		$(use_enable video-thumbnails) \
		--disable-hal \
		--enable-inotify \
		--disable-pixmaps \
		$(use_with gtk3 gtk3 "yes")
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update

	einfo
	elog "To mount as non-root user you need one of the following:"
	elog "  sys-apps/udevil (recommended, see below)"
	elog "  sys-apps/pmount"
	elog "  sys-fs/udisks:0"
	elog "  sys-fs/udisks:2"
	elog "To support ftp/nfs/smb/ssh URLs in the path bar you need:"
	elog "  sys-apps/udevil"
	elog "To perform as root functionality you need one of the following:"
	elog "  x11-misc/ktsuss"
	elog "  kde-plasma/kde-cli-tools[kdesu]"
	elog "Other optional dependencies:"
	elog "  sys-apps/dbus"
	elog "  sys-process/lsof (device processes)"
	elog "  virtual/eject (eject media)"
	einfo
	if ! has_version 'sys-fs/udisks' ; then
		elog "When using SpaceFM without udisks, and without the udisks-daemon running,"
		elog "you may need to enable kernel polling for device media changes to be detected."
		elog "See /usr/share/doc/${PF}/html/spacefm-manual-en.html#devices-kernpoll"
		has_version '<virtual/udev-173' && ewarn "You need at least udev-173"
		kernel_is lt 2 6 38 && ewarn "You need at least kernel 2.6.38"
		einfo
	fi
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}
