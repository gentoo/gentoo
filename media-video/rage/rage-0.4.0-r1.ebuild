# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg

DESCRIPTION="Video and audio player written using EFL"
HOMEPAGE="https://www.enlightenment.org/about-rage"
SRC_URI="https://download.enlightenment.org/rel/apps/rage/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="|| ( dev-libs/efl[X] dev-libs/efl[wayland] )
	>=dev-libs/efl-1.26.1[gstreamer]
	media-plugins/gst-plugins-meta[ffmpeg]"
RDEPEND="${DEPEND}"

pkg_postinst() {
	xdg_pkg_postinst

	elog "Control your media file support with media-plugins/gst-plugins-meta[*]"
	elog "and/or media-video/ffmpeg[*]"
}
