# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/pdfpc/pdfpc-4.0.0.ebuild,v 1.2 2015/06/05 13:17:10 xmw Exp $

EAPI=5

inherit cmake-utils

DESCRIPTION="Presenter console with multi-monitor support for PDF files"
HOMEPAGE="http://pdfpc.github.io"
SRC_URI="https://github.com/${PN}/${PN}/releases/download/v${PV}/${PN}-v${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-text/poppler:=[cairo]
	dev-libs/glib:2
	dev-libs/libgee:0.8
	gnome-base/librsvg
	media-libs/gstreamer:1.0
	media-libs/gst-plugins-base:1.0
	x11-libs/gtk+:3"
DEPEND="${RDEPEND}
	>=dev-lang/vala-0.26"

S=${WORKDIR}/${PN}-v${PV}

src_prepare() {
	sed -i -e "s/valac-0.20/valac-0.28 valac-0.26 valac-0.24 valac-0.22 valac-0.20/" cmake/Vala_CMake/vala/FindVala.cmake || die
}

src_configure(){
	local mycmakeargs=(
		-DSYSCONFDIR="${EPREFIX}/etc"
	)
	cmake-utils_src_configure
}
