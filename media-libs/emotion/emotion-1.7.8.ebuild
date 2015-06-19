# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/emotion/emotion-1.7.8.ebuild,v 1.3 2013/10/12 20:11:25 vapier Exp $

EAPI="4"

inherit enlightenment

DESCRIPTION="video libraries for e17"
SRC_URI="http://download.enlightenment.org/releases/${P}.tar.bz2"

LICENSE="BSD-2"
KEYWORDS="~amd64 ~x86"
IUSE="gstreamer static-libs vlc xine"

DEPEND=">=media-libs/evas-1.7.8
	>=media-libs/edje-1.7.8
	>=dev-libs/ecore-1.7.8
	>=dev-libs/eina-1.7.8
	>=dev-libs/eeze-1.7.4
	vlc? ( media-video/vlc )
	xine? ( >=media-libs/xine-lib-1.1.1 )
	!gstreamer? ( !vlc? ( !xine? ( >=media-libs/xine-lib-1.1.1 ) ) )
	gstreamer? (
		=media-libs/gstreamer-0.10*
		=media-libs/gst-plugins-good-0.10*
		=media-plugins/gst-plugins-ffmpeg-0.10*
	)"
RDEPEND=${DEPEND}

src_configure() {
	if ! use vlc && ! use xine && ! use gstreamer ; then
		E_ECONF+=(
			--enable-xine
			--disable-gstreamer
			--disable-generic-vlc
		)
	else
		E_ECONF+=(
			$(use_enable xine)
			$(use_enable gstreamer)
			$(use_enable vlc generic-vlc)
		)
	fi

	E_ECONF+=(
		$(use_enable doc)
	)

	if use gstreamer ; then
		addpredict "/root/.gconfd"
		addpredict "/root/.gconf"
	fi

	enlightenment_src_configure
}
