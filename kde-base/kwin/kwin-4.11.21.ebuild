# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kde-workspace"
DECLARATIVE_REQUIRED="always"
OPENGL_REQUIRED="always"

#VIRTUALX_REQUIRED=test
RESTRICT=test
# test 8: kwin-TestVirtualDesktops hangs even with virtualx

inherit flag-o-matic kde4-meta

DESCRIPTION="KDE window manager"
HOMEPAGE+=" http://userbase.kde.org/KWin"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux"
IUSE="debug gles opengl wayland"

COMMONDEPEND="
	$(add_kdebase_dep kactivities)
	$(add_kdebase_dep kdelibs opengl)
	$(add_kdebase_dep kephal)
	$(add_kdebase_dep libkworkspace)
	$(add_kdebase_dep liboxygenstyle)
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	>=x11-libs/libXrandr-1.2.1
	x11-libs/libXrender
	x11-libs/libXxf86vm
	opengl? ( >=media-libs/mesa-7.10 )
	gles? ( >=media-libs/mesa-7.12[egl(+),gles2] )
	wayland? ( >=media-libs/mesa-9.0[egl(+),wayland] )
"
DEPEND="${COMMONDEPEND}
	x11-libs/xcb-util-renderutil
	x11-proto/compositeproto
	x11-proto/damageproto
	x11-proto/fixesproto
	x11-proto/randrproto
	x11-proto/renderproto
"
RDEPEND="${COMMONDEPEND}
	x11-apps/scripts
"

KMEXTRACTONLY="
	ksmserver/
	libs/kephal/
	libs/oxygen/
"

# you need one of these
REQUIRED_USE="!opengl? ( gles ) !gles? ( opengl ) wayland? ( gles )"

src_configure() {
	# FIXME Remove when activity API moved away from libkworkspace
	append-cppflags "-I${EPREFIX}/usr/include/kworkspace"

	local mycmakeargs=(
		$(cmake-utils_use_with gles OpenGLES)
		$(cmake-utils_use gles KWIN_BUILD_WITH_OPENGLES)
		$(cmake-utils_use_with opengl OpenGL)
		$(cmake-utils_use_with wayland Wayland)
		-DWITH_X11_Xcomposite=ON
	)

	kde4-meta_src_configure
}
