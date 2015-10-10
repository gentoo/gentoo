# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
VALA_MIN_API_VERSION="0.14"

inherit autotools vala

MY_P=${P}dev

DESCRIPTION="An application which allows any application to be docked into the system notification area"
HOMEPAGE="http://alltray.trausch.us/"
SRC_URI="https://code.launchpad.net/${PN}/trunk/${PV}dev/+download/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="dev-libs/glib:2
	gnome-base/libgtop:2
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	x11-libs/libwnck:1"
DEPEND="${RDEPEND}
	$(vala_depend)
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

DOCS=( AUTHORS ChangeLog HACKING NEWS README )

src_prepare() {
	sed -i -e 's:-DG.*DISABLE_DEPRECATED::' src/Makefile.{am,in} || die #391101

	sed -i \
		-e '/Encoding/d' \
		-e '/Categories/s:Application;::' \
		-e '/Icon/s:.png::' \
		data/alltray.desktop{,.in} || die

	vala_src_prepare
	sed -i -e '/AC_PATH_PROG/s:valac:${VALAC}:g' configure.ac || die

	eautoreconf
}
