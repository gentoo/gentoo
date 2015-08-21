# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
KEYWORDS="~amd64 ~ppc ~x86 ~x86-linux"
IUSE="debug v4l"

RDEPEND="
	dev-libs/qjson
	$(add_kdebase_dep kdelibs)
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
		-DWITH_Nepomuk=OFF
		$(cmake-utils_use_with v4l LibV4L2)
	)
	kde4-base_src_configure
}
