# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils gnome2

MY_PN=${PN}2

DESCRIPTION="A contact database for Gnome"
LICENSE="GPL-3"
HOMEPAGE="http://rubrica.berlios.de/"
SLOT="0"
KEYWORDS="~amd64 x86"
SRC_URI="
	mirror://berlios/${PN}/${MY_PN}-${PV}.tar.bz2
	mirror://gentoo/${P}-hu.po.bz2
"

RDEPEND="
	dev-libs/glib:2
	dev-libs/libxml2
	>=gnome-base/libglade-2
	gnome-base/gconf:2
	x11-libs/gtk+:2
	x11-libs/libnotify
"
DEPEND="
	${RDEPEND}
	>=sys-devel/gettext-0.16.1
	dev-util/intltool
	virtual/pkgconfig
"

S=${WORKDIR}/${MY_PN}-${PV}

pkg_setup() {
	G2CONF="${G2CONF}
		--disable-dependency-tracking
		--disable-static
		--with-html-dir=/usr/share/doc/${PF}/html"

	DOCS="AUTHORS ChangeLog CREDITS NEWS README TODO"
}

src_prepare() {
	mv "${WORKDIR}"/${P}-hu.po po/hu.po || die
	epatch "${FILESDIR}"/${P}-libnotify-0.7.patch
	epatch "${FILESDIR}"/${P}-fix-menu-language.patch
	epatch "${FILESDIR}"/${P}-missing-icons.patch
	epatch "${FILESDIR}"/${P}-url-crash.patch
	epatch "${FILESDIR}"/${P}-linguas_hu.patch
	epatch "${FILESDIR}"/${P}-libm.patch
	epatch "${FILESDIR}"/${P}-gthread.patch
	epatch "${FILESDIR}"/${P}-schema.patch
	eautoreconf
}

src_install() {
	gnome2_src_install
	domenu "${FILESDIR}"/${MY_PN}.desktop
	prune_libtool_files
}
