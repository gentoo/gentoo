# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit vdr-plugin-2

VERSION="1041" # every bump, new version

DESCRIPTION="VDR Plugin: marks advertisements in VDR recordings"
HOMEPAGE="http://projects.vdr-developer.org/projects/plg-markad/"
SRC_URI="mirror://vdr-developerorg/${VERSION}/${P}.tgz"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-1.6
		virtual/ffmpeg[mp3,x264]
		!media-video/noad"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${VDRPLUGIN}-${PV}/plugin"
S2="${WORKDIR}/${VDRPLUGIN}-${PV}/command"

# vdr-plugin-2.eclass changes
PO_SUBDIR="../command"

src_prepare() {
	vdr-plugin-2_src_prepare

	cd "${S2}"
	epatch "${FILESDIR}/${PN}-0.1.4-libav9.patch"
	sed -i Makefile \
		-e "s:\$(CXXFLAGS) \$(OBJS):\$(CXXFLAGS) \$(LDFLAGS) \$(OBJS):" \
		-e "s:\@\$(STRIP) \$(DESTDIR)/usr/bin/markad::"

	if has_version ">=media-video/vdr-1.7.15"; then
		sed -e "s:2001:6419:" -i markad-standalone.cpp
	fi

	epatch "${FILESDIR}/${P}_ffmpeg-2.patch"
}

src_compile() {
	vdr-plugin-2_src_compile

	cd "${S2}"
	emake markad || die "Compiling command-line markad binary failed"
}

src_install() {
	vdr-plugin-2_src_install

	cd "${S2}"
	emake install DESTDIR="${D}" || die "emake install failed"

	cd "${WORKDIR}/${VDRPLUGIN}-${PV}"
	dodoc README HISTORY
}
