# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools linux-info optfeature xdg

DESCRIPTION="A multi-panel tabbed file manager"
HOMEPAGE="https://ignorantguru.github.io/spacefm/"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/IgnorantGuru/${PN}.git"
	EGIT_BRANCH="next"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/IgnorantGuru/spacefm/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2 LGPL-2.1"
SLOT="0"
IUSE="+startup-notification +video-thumbnails"

RDEPEND="dev-libs/glib:2
	dev-util/desktop-file-utils
	virtual/udev
	virtual/freedesktop-icon-theme
	x11-libs/cairo
	x11-libs/gdk-pixbuf
	x11-libs/gtk+:3
	x11-libs/pango
	x11-libs/libX11
	x11-misc/shared-mime-info
	startup-notification? ( x11-libs/startup-notification )
	video-thumbnails? ( media-video/ffmpegthumbnailer )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-9999-include-sysmacros.patch
	"${FILESDIR}"/${PN}-fno-common.patch
	"${FILESDIR}"/${PN}-dash.patch #891181
	"${FILESDIR}"/${PN}-gcc14-build-fix.patch #928492
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable startup-notification) \
		$(use_enable video-thumbnails) \
		--disable-hal \
		--enable-inotify \
		--disable-pixmaps \
		--with-gtk3
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "mounting as non-root user" sys-apps/udevil sys-apps/pmount sys-fs/udisks
	optfeature "supporting ftp/nfs/smb/ssh URLs in the path bar" sys-apps/udevil
	optfeature "performing as root" x11-misc/ktsuss kde-plasma/kde-cli-tools[kdesu]
	# sys-apps/util-linux is required for eject
	optfeature "other optional dependencies" sys-apps/dbus sys-process/lsof sys-apps/util-linux

	if ! has_version 'sys-fs/udisks' ; then
		elog "When using SpaceFM without udisks, and without the udisks-daemon running,"
		elog "you may need to enable kernel polling for device media changes to be detected."
		elog "See /usr/share/doc/${PF}/html/spacefm-manual-en.html#devices-kernpoll"
	fi
}
