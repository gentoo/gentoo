# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMMODULE="kscreensaver"
KMNAME="kdeartwork"
OPENGL_REQUIRED="optional"
KDE_SCM="svn"
inherit kde4-meta

DESCRIPTION="Extra screensavers for kde"
KEYWORDS="amd64 ~x86"
IUSE="debug +eigen +kexiv2 xscreensaver"

# libkworkspace - only as a stub to provide KDE4Workspace config
RDEPEND="
	$(add_kdebase_dep kscreensaver '' 4.11)
	$(add_kdebase_dep libkworkspace '' 4.11)
	media-libs/libart_lgpl
	x11-libs/libX11
	x11-libs/libXt
	virtual/glu
	virtual/opengl
	kexiv2? ( $(add_kdeapps_dep libkexiv2) )
	xscreensaver? ( x11-misc/xscreensaver )
"
DEPEND="${RDEPEND}
	eigen? ( dev-cpp/eigen:3 )
"

PATCHES=(
	"${FILESDIR}/${PN}-xscreensaver.patch"
	"${FILESDIR}/${PN}-4.5.95-webcollage.patch"
	"${FILESDIR}/${PN}-15.08.3-missing-include.patch"
)

src_configure() {
	local mycmakeargs=(
		-DKSCREENSAVER_SOUND_SUPPORT=ON
		-DOPENGL=ON
		$(cmake-utils_use_with eigen Eigen3)
		$(cmake-utils_use_with kexiv2)
		$(cmake-utils_use_with xscreensaver)
	)

	kde4-meta_src_configure
}
