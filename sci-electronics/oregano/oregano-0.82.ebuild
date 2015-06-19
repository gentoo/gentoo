# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-electronics/oregano/oregano-0.82.ebuild,v 1.6 2014/08/10 20:28:33 slyfox Exp $

EAPI="4"

inherit autotools eutils fdo-mime vcs-snapshot gnome2-utils

DESCRIPTION="Oregano is an application for schematic capture and simulation of electrical circuits"
HOMEPAGE="https://github.com/marc-lorber/oregano"
SRC_URI="https://github.com/marc-lorber/${PN}/tarball/v${PV} -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

CDEPEND="dev-libs/libxml2:2
	x11-libs/goocanvas:2.0
	x11-libs/gtk+:3
	x11-libs/gtksourceview:3.0
	app-text/rarian"
DEPEND="${CDEPEND}
	virtual/pkgconfig"
RDEPEND="${CDEPEND}
	|| ( gnome-base/dconf gnome-base/gconf )
	sci-electronics/electronics-menu"

src_prepare() {
	epatch "${FILESDIR}"/${P}-format-security.patch
	epatch "${FILESDIR}"/${P}-remove.unneeded.docs.patch
	epatch "${FILESDIR}"/${P}-asneeded.patch
	# Do not use GTK_DISABLE_DEPRECATED (needed by >=gtk+-3.8.1
	sed -i -e "s/-DGTK_DISABLE_DEPRECATED//g" src/sheet/Makefile.am || die
	sed -i -e "s/-DGTK_DISABLE_DEPRECATED//g" src/Makefile.am || die
	sed -i -e "s/(OREGANO_LIBS)/(OREGANO_LIBS) -lm/" src/Makefile.am || die
	# Aclocal 1.13 deprecated error #467708
	epatch "${FILESDIR}"/${P}-automake.patch
	eautoreconf
}

src_configure() {
	econf --disable-update-mimedb --disable-silent-rules
}

src_install() {
	emake DESTDIR="${D}" oreganodocdir=/usr/share/doc/${PF} install
}

pkg_preinst() {
	gnome2_schemas_savelist
}

pkg_postinst() {
	gnome2_schemas_update
	fdo-mime_desktop_database_update
	elog "You'll need to emerge your prefered simulation backend"
	elog "such ngspice or gnucap for simulation to work."
	elog "As an alternative generate a netlist and use sci-electronics/spice"
	elog "from the command line for simulation."
}

pkg_postrm() {
	gnome2_schemas_update
}
