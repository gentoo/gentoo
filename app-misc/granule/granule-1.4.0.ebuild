# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
inherit eutils

DESCRIPTION="A flashcard program that implements Leitner cardfile methodology"
HOMEPAGE="http://granule.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-7.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-cpp/gtkmm-2.4.1:2.4
	>=dev-cpp/libassa-3.5.0
	x11-libs/gtk+:2
	dev-cpp/glibmm:2
	>=dev-libs/libsigc++-2.0
	x11-libs/pango
	dev-libs/glib:2
	dev-libs/libxml2"
DEPEND="${RDEPEND}
	sys-devel/gettext
	dev-util/intltool
	virtual/pkgconfig"

S="${WORKDIR}/${P}-7"

src_prepare() {
	epatch "${FILESDIR}"/${P}-fix-template-with-permissive.patch
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS ChangeLog NEWS README
}
