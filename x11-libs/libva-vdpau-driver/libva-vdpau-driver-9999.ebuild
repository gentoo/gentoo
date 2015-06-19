# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-libs/libva-vdpau-driver/libva-vdpau-driver-9999.ebuild,v 1.3 2014/06/18 21:02:10 mgorny Exp $

EAPI=5

SCM=""
if [ "${PV%9999}" != "${PV}" ] ; then # Live ebuild
	SCM=git-2
	EGIT_BRANCH=master
	EGIT_REPO_URI="git://anongit.freedesktop.org/vaapi/vdpau-driver"
fi
AUTOTOOLS_AUTORECONF="yes"
inherit autotools-multilib ${SCM}

DESCRIPTION="VDPAU Backend for Video Acceleration (VA) API"
HOMEPAGE="http://www.freedesktop.org/wiki/Software/vaapi"
if [ "${PV%9999}" != "${PV}" ] ; then # Live ebuild
	SRC_URI=""
	S="${WORKDIR}/${PN}"
else
	SRC_URI="http://www.freedesktop.org/software/vaapi/releases/libva-vdpau-driver/${P}.tar.bz2"
fi

LICENSE="GPL-2"
SLOT="0"
if [ "${PV%9999}" = "${PV}" ] ; then
	KEYWORDS="~amd64 ~x86"
else
	KEYWORDS=""
fi
IUSE="debug opengl"

RDEPEND=">=x11-libs/libva-1.2.1-r1[X,opengl?,${MULTILIB_USEDEP}]
	opengl? ( >=virtual/opengl-7.0-r1[${MULTILIB_USEDEP}] )
	>=x11-libs/libvdpau-0.7[${MULTILIB_USEDEP}]
	!x11-libs/vdpau-video"

DEPEND="${DEPEND}
	virtual/pkgconfig"

DOCS=( NEWS README AUTHORS )

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable debug)
		$(use_enable opengl glx)
	)
	autotools-utils_src_configure
}
