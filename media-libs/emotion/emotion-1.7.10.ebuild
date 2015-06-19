# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/emotion/emotion-1.7.10.ebuild,v 1.1 2015/03/17 02:07:08 vapier Exp $

EAPI="5"

if [[ ${PV} == "9999" ]] ; then
	EGIT_SUB_PROJECT="legacy"
	EGIT_URI_APPEND=${PN}
	EGIT_BRANCH=${PN}-1.7
else
	SRC_URI="http://download.enlightenment.org/releases/${P}.tar.bz2"
	EKEY_STATE="snap"
fi

inherit enlightenment

DESCRIPTION="video libraries for e17"

LICENSE="BSD-2"
# The video deps (vlc/xine-lib/gstreamer) are a pain to keyword.
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="gstreamer static-libs vlc xine"

DEPEND=">=media-libs/evas-${PV}
	>=media-libs/edje-${PV}
	>=dev-libs/ecore-${PV}
	>=dev-libs/eina-${PV}
	>=dev-libs/eeze-${PV}
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
