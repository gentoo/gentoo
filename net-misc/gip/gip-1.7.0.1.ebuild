# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils versionator

MY_PV="$(replace_version_separator 3 '-')"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A nice GNOME GUI for making IP address based calculations"
HOMEPAGE="http://code.google.com/p/gip/"
SRC_URI="
	http://gip.googlecode.com/files/${MY_P}.tar.gz
	mirror://debian/pool/main/g/${PN}/${PN}_${MY_PV}-3.debian.tar.gz"
#http://ftp.de.debian.org/debian/pool/main/g/gip/gip_1.7.0-1-3.debian.tar.gz
#http://dl.debain.org/gip/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-cpp/gtkmm:2.4
	dev-libs/glib:2
	dev-libs/libsigc++:2"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch \
		"${WORKDIR}"/debian/patches/*.diff \
		"${FILESDIR}"/${P}-asneeded.patch

	sed \
		-e "s:g++:$(tc-getCXX):g" \
		-i installer/build_files.sh

#	sed \
#		-e 's:CFLAGS=":CFLAGS+=" :g' \
#		-i build.sh || die

#		"${FILESDIR}"/${PN}-1.6.1.1-asneeded.patch

#		"${FILESDIR}/${P}-libsigcpp.patch" \
#	sed -i -e 's@INST_PIXMAPDIR=\"$INST_PREFIX/lib/$EXECUTABLE\"@INST_PIXMAPDIR=\"/usr/lib/$EXECUTABLE\"@g' build.sh
#	sed -i -e 's@INST_PIXMAPDIR=\"/usr/lib/$EXECUTABLE\"@INST_PIXMAPDIR=\"$INST_PREFIX/lib/$EXECUTABLE\"@g' build.sh
#	sed -i -e 's@INST_DOCDIR=\"$INST_PREFIX/doc/$EXECUTABLE\"@INST_DOCDIR=\"$INST_PREFIX/share/doc/'${PF}'\"@g' build.sh
}

src_compile() {
	# Crazy build system...
	export CXXFLAGS="${CXXFLAGS}"
	./build.sh --prefix "${D}/usr" || die "./build failed"
}

src_install() {
	dodoc AUTHORS ChangeLog README
	# Crazy build system...
	./build.sh --install --prefix "${D}/usr" || die "./build --install failed"
	make_desktop_entry gip "GIP IP Address Calculator" gnome-calc3 Network
}
