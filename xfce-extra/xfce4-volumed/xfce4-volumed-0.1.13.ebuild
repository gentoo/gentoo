# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit xfconf

DESCRIPTION="Daemon to control volume up/down and mute keys"
HOMEPAGE="https://launchpad.net/xfce4-volumed"
SRC_URI="mirror://xfce/src/apps/${PN}/0.1/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="alsa debug libnotify oss"

COMMON_DEPEND="dev-libs/keybinder:0
	media-libs/gstreamer:0.10
	media-libs/gst-plugins-base:0.10
	>=xfce-base/xfconf-4.8
	libnotify? ( x11-libs/libnotify )"
RDEPEND="${COMMON_DEPEND}
	alsa? ( media-plugins/gst-plugins-alsa:0.10 )
	oss? ( media-plugins/gst-plugins-oss:0.10 )
	!alsa? ( !oss? ( media-plugins/gst-plugins-meta:0.10 ) )"
DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

pkg_setup() {
	XFCONF=(
		$(use_enable debug)
		$(use_with libnotify)
		)

	DOCS=( AUTHORS ChangeLog README THANKS )
}
