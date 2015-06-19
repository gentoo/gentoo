# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-plugins/mediastreamer-x264/mediastreamer-x264-1.4.2-r1.ebuild,v 1.1 2015/02/07 20:19:47 mgorny Exp $

EAPI=5

MY_P="msx264-${PV}"

DESCRIPTION="mediastreamer plugin: add H264 support"
HOMEPAGE="http://www.linphone.org/"
SRC_URI="mirror://nongnu/linphone/plugins/sources/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="libav"

RDEPEND=">=media-libs/mediastreamer-2.7.0:=[video]
	>=media-libs/x264-0.0.20100118:=
	libav? ( media-video/libav:0= )
	!libav? ( media-video/ffmpeg:0= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

src_configure() {
	# strict: don't want -Werror
	econf \
		--disable-strict
}
