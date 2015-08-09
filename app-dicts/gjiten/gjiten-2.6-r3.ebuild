# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
GCONF_DEBUG="no"

inherit autotools eutils gnome2 readme.gentoo

DESCRIPTION="A Japanese dictionary program for Gnome"
HOMEPAGE="http://gjiten.sourceforge.net/"
SRC_URI="http://gjiten.sourceforge.net/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RESTRICT="test"

RDEPEND="
	>=gnome-base/libgnome-2.2
	>=gnome-base/libgnomeui-2.2
	>=gnome-base/libglade-2
"
DEPEND="${RDEPEND}
	app-text/rarian
	dev-util/intltool
	app-text/xmlto
	app-text/docbook-xml-dtd:4.1.2
	virtual/pkgconfig
"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="Dictionary files are necessary in order for
Gjiten to function.

Download dictionary files from:
http://ftp.cc.monash.edu.au/pub/nihongo/00INDEX.html#dic_fil

You need kanjidic and edict at a minimum.  Dictionary files
must be converted to UTF-8 format - check the Gjiten help
and README files for details.

A shell script is available from
the Gjiten homepage(${HOMEPAGE}) to
download and convert the dictionary files, but you need
to put the files in /usr/share/gjiten after running the script."

src_prepare() {
	DOCS="AUTHORS BUGS ChangeLog NEWS README TODO"

	epatch "${FILESDIR}"/${P}-pref.patch
	epatch "${FILESDIR}"/${P}-drop-gnome.patch
	epatch "${FILESDIR}"/${P}-desktop.patch

	AM_OPTS="--foreign" eautoreconf
	gnome2_src_prepare
}

src_install() {
	gnome2_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	gnome2_pkg_postinst
	readme.gentoo_print_elog
}
