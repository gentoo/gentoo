# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop optfeature

DESCRIPTION="A lightweight window manager initially based on aewm++"
HOMEPAGE="
	https://www.pekwm.se/
	https://github.com/pekwm/pekwm
"
SRC_URI="
	https://github.com/pekwm/${PN}/releases/download/release-${PV}/pekwm-${PV}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~ppc ~x86"
IUSE="debug +jpeg pango +png truetype xinerama +xpm"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext
	jpeg? ( media-libs/libjpeg-turbo:= )
	pango? ( x11-libs/pango x11-libs/cairo[X] )
	png? ( media-libs/libpng:0= )
	truetype? ( x11-libs/libXft )
	xinerama? ( x11-libs/libXinerama )
	xpm? ( x11-libs/libXpm )"

DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

src_configure() {
	local mycmakeargs=(
		-DENABLE_IMAGE_JPEG=$(usex jpeg)
		-DENABLE_IMAGE_PNG=$(usex png)
		-DENABLE_XINERAMA=$(usex xinerama)
		-DENABLE_XFT=$(usex truetype)
		-DENABLE_IMAGE_XPM=$(usex xpm)
		-DENABLE_PANGO=$(usex pango)
	)

	CMAKE_BUILD_TYPE=$(usex debug Debug)

	cmake_src_configure
}

src_install() {

	cmake_src_install

	# Install contributor scripts into doc folder
	docinto contrib
	dodoc "${S}"/contrib/lobo/*.{pl,vars,png} "${S}"/contrib/lobo/README

	# Insert an Xsession
	exeinto /etc/X11/Sessions
	newexe - pekwm <<- _EOF_
		#!/bin/sh
		/usr/bin/pekwm
	_EOF_

	# Insert a GDM/KDM xsession file
	make_session_desktop ${PN} ${PN}
}

pkg_postinst() {

	elog "Since pekwm 0.2.0 themes can be installed and maintained using "
	elog "pekwm_theme [install|uninstall|show|search|new|update]."
	elog "Check https://www.pekwm.se/themes/ for details."

	elog

	optfeature "themes management (pekwm_theme) support" dev-vcs/git

	elog

	elog "User contributed scripts have been installed into:"
	elog "${EROOT}/usr/share/doc/${PF}/contrib"

	elog

	elog "Pekwm supports Pango fonts since 0.3.0."
}
