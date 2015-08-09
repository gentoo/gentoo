# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils fdo-mime flag-o-matic scons-utils

DESCRIPTION="Oregano is an application for schematic capture and simulation of electrical circuits"
SRC_URI="mirror://debian/pool/main/${PN:0:1}/${PN}/${P/-/_}.orig.tar.gz"
HOMEPAGE="http://oregano.gforge.lug.fi.uba.ar/" # broken
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
LICENSE="GPL-2"
IUSE=""

CDEPEND="
	dev-libs/libxml2:2
	x11-libs/gtk+:2
	gnome-base/libglade:2.0
	gnome-base/libgnome
	>=gnome-base/libgnomeui-2.12
	>=gnome-base/libgnomecanvas-2.12
	>=x11-libs/cairo-1.2
	x11-libs/gtksourceview:2.0"
DEPEND="${CDEPEND}
	>=dev-util/scons-0.96.1
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	sci-electronics/electronics-menu"

src_prepare() {
	# patches from debian
	epatch "${FILESDIR}/${P}-desktop_file_update.patch"
	epatch "${FILESDIR}/${P}-scons_env_flags.patch"
	epatch "${FILESDIR}/${P}-fix-libm.patch"
}

src_compile() {
	# bug 369875
	strip-unsupported-flags
	# see bug 363833
	append-cflags -fno-omit-frame-pointer
	escons --cache-disable PREFIX=/usr
}

src_install() {
	escons --cache-disable PREFIX=/usr DESTDIR="${D}" RunUpdateMimeDatabase=no \
		install
	dodoc AUTHORS NEWS README docs/Library-HOWTO.txt
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	elog "You'll need to emerge your prefered simulation backend"
	elog "such ngspice or gnucap for simulation to work."
	elog "As an alternative generate a netlist and use sci-electronics/spice"
	elog "from the command line for simulation."
}
