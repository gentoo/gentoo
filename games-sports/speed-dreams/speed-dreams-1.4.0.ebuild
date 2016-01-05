# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils versionator games

DESCRIPTION="A fork of the famous open racing car simulator TORCS"
HOMEPAGE="http://speed-dreams.sourceforge.net/"
SRC_URI="mirror://sourceforge/speed-dreams/${P}-r2307-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="xrandr"

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/freeglut
	media-libs/openal
	media-libs/freealut
	x11-libs/libX11
	x11-libs/libXxf86vm
	xrandr? ( x11-libs/libXrandr )
	sys-libs/zlib
	>=media-libs/libpng-1.2.40:0"
DEPEND="${RDEPEND}
	>=media-libs/plib-1.8.3
	x11-proto/xproto
	x11-libs/libXext
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXt
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXrender
	xrandr? ( x11-proto/randrproto )"

S=${WORKDIR}/${PN}-$(get_version_component_range 1-3)-src

src_prepare() {
	# http://sourceforge.net/apps/trac/speed-dreams/ticket/111
	MAKEOPTS="${MAKEOPTS} -j1"

	epatch \
			"${FILESDIR}"/${P}-asneeded.patch \
			"${FILESDIR}"/${P}-automake.patch \
			"${FILESDIR}"/${P}-libpng15.patch

	sed -i \
		-e '/ADDCFLAGS/s: -O2::' \
		configure.in || die
	sed -i \
		-e '/COPYING/s:=.*:= \\:' \
		Makefile || die
	sed -i \
		-e "/^datadir/s:=.*:= ${GAMES_DATADIR}/${PN}:" \
		Make-config.in || die

	eautoreconf
}

src_configure() {
	addpredict $(echo /dev/snd/controlC? | sed 's/ /:/g')
	[[ -e /dev/dsp ]] && addpredict /dev/dsp
	egamesconf \
		--prefix=/usr \
		--bindir="${GAMES_BINDIR}" \
		$(use_enable xrandr)
}

src_install() {
	emake DESTDIR="${D}" install datainstall

	find "${D}" -name Makefile -exec rm -f {} +

	dodoc CHANGES README TODO

	newicon icon.svg ${PN}.svg
	make_desktop_entry ${PN} "Speed Dreams"

	prepgamesdirs
}
