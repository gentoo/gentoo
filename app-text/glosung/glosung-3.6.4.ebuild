# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils toolchain-funcs
DESCRIPTION="Watch word program for the GNOME2 desktop (watch word (german): losung)"
HOMEPAGE="http://www.godehardt.org/losung.html"
SRC_URI="mirror://sourceforge/glosung/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PATCHES=("${FILESDIR}/${PN}-3.6.4-scons-respectflags.patch")

RDEPEND="
	dev-libs/libxml2
	>=gnome-base/gconf-2.0:2
	>=gnome-base/libgnome-2
	>=gnome-base/libgnomeui-2
	net-misc/curl
	>=x11-libs/gtk+-2.10:2
"

DEPEND="${RDEPEND}
	>=dev-util/scons-0.93
	>=dev-util/intltool-0.22
	>=sys-devel/gettext-0.10
	virtual/pkgconfig
"

src_compile() {
	tc-export CC
	scons ${MAKEOPTS} || die "scons make died"
}

src_install() {
	scons install DESTDIR="${D}" || die "scons install died"
	#Ships with an ISO-8859 encoded .desktop file, which causes validation to fail, so ship a UTF-8 version
	cp "${FILESDIR}/glosung.desktop" "${D}/usr/share/applications"
}
