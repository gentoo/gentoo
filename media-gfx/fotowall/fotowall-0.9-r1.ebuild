# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit qt4-r2

MY_P="${P/f/F}"

DESCRIPTION="Qt4 tool for creating wallpapers"
HOMEPAGE="http://www.enricoros.com/opensource/fotowall/"
SRC_URI="https://fotowall.googlecode.com/files/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug opengl webcam"

DEPEND="dev-qt/qtgui:4
	dev-qt/qtsvg:4
	opengl? ( dev-qt/qtopengl:4 )"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS="README.markdown"

src_prepare() {
	qt4-r2_src_prepare

	if ! use opengl; then
		sed -i "/QT += opengl/d" "${PN}.pro" || die "sed failed"
	fi
}

src_configure() {
	if ! use webcam; then
		eqmake4 ${PN}.pro "CONFIG+=no-webcam"
	else
		eqmake4
	fi
}
