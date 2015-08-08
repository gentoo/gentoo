# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils games rpm

DS="${PV/*_pre}"
DESCRIPTION="FPS level editor"
HOMEPAGE="http://www.qeradiant.com/?data=editors/gtk"
SRC_URI="http://zerowing.idsoftware.com/files/radiant/nightly/${PV:0:3}/gtkradiant-${PV/_pre*}-${DS:0:4}-${DS:4:2}-${DS:6:2}.i386.rpm"

LICENSE="qeradiant"
SLOT="0"
KEYWORDS="-* x86"
IUSE=""

RDEPEND="=media-libs/libpng-1.2*
	sys-libs/zlib
	app-crypt/mhash
	=dev-libs/glib-2*
	x11-libs/gtk+:2
	dev-libs/atk
	x11-libs/pango
	x11-libs/gtkglext
	dev-libs/libxml2
	sys-libs/glibc
	virtual/opengl"

S=${WORKDIR}/opt/${PN}

src_install() {
	local dir="${GAMES_PREFIX_OPT}/${PN}"
	dodir "${dir}"

	cp -pPR * "${D}/${dir}/"
	games_make_wrapper q3map2 ./q3map2.x86 "${dir}"
	games_make_wrapper radiant ./radiant.x86 "${dir}"

	prepgamesdirs
}
