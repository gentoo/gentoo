# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils versionator

V1=$(get_version_component_range 1 ${PV})
V2=$(get_version_component_range 2 ${PV})
V3=$(get_version_component_range 3 ${PV})
V4=$(get_version_component_range 4 ${PV})
V5=$(get_version_component_range 5 ${PV})

MY_P=molscript-${V1}.${V2}.${V3}pov${V4}.${V5}

DESCRIPTION="Modified molscript that uses POV-Ray, does thermal ellipsoids, and more"
HOMEPAGE="https://sites.google.com/site/timfenn/povscript"
SRC_URI="https://sites.google.com/site/timfenn/povscript/${MY_P}.tar.gz"

LICENSE="glut molscript"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	dev-libs/glib:2
	media-libs/freeglut
	media-libs/giflib
	>=media-libs/libpng-1.4
	sci-libs/gts
	sys-libs/zlib
	virtual/glu
	virtual/jpeg
	virtual/opengl
	x11-libs/libX11"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${P}-libpng15.patch
}

src_install() {
	emake DESTDIR="${D}" install
	cd "${D}"/usr/bin
	mv molscript povscript+
	mv molauto povauto+
}

pkg_postinst() {
	elog "You must install media-gfx/povray to use the POV backend,"
	elog "which is one of the main features of this over molscript."
}
