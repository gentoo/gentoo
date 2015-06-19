# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/kdenlive/kdenlive-0.9.8.ebuild,v 1.3 2015/02/14 14:38:35 ago Exp $

EAPI=5

KDE_HANDBOOK="optional"
KDE_MINIMAL="4.13.1"
OPENGL_REQUIRED="always"
inherit kde4-base

DESCRIPTION="A non-linear video editing suite for KDE"
HOMEPAGE="http://www.kdenlive.org/"
SRC_URI="mirror://kde/stable/${PN}/${PV}/src/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 ~ppc x86 ~x86-linux"
IUSE="debug nepomuk v4l"

RDEPEND="
	dev-libs/qjson
	$(add_kdebase_dep kdelibs 'nepomuk?')
	>=media-libs/mlt-0.9.0[ffmpeg,sdl,xml,melt,qt4,kdenlive]
	virtual/ffmpeg[encode,sdl,X]
	v4l? ( media-libs/libv4l )
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

DOCS=(AUTHORS ChangeLog README)

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use_with nepomuk)
		$(cmake-utils_use_with v4l LibV4L2)
	)
	kde4-base_src_configure
}
