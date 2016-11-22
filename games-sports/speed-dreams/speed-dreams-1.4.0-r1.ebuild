# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils versionator

DESCRIPTION="A fork of the famous open racing car simulator TORCS"
HOMEPAGE="http://speed-dreams.sourceforge.net/"
SRC_URI="mirror://sourceforge/speed-dreams/${P}-r2307-src.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="xrandr"

RDEPEND="virtual/opengl
	virtual/glu
	media-libs/freealut
	media-libs/freeglut
	>=media-libs/libpng-1.2.40:0
	media-libs/openal
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXxf86vm
	xrandr? ( x11-libs/libXrandr )"
DEPEND="${RDEPEND}
	>=media-libs/plib-1.8.3
	x11-libs/libICE
	x11-libs/libSM
	x11-libs/libXext
	x11-libs/libXi
	x11-libs/libXt
	x11-libs/libXmu
	x11-libs/libXrender
	x11-proto/xproto
	xrandr? ( x11-proto/randrproto )"

S=${WORKDIR}/${PN}-$(get_version_component_range 1-3)-src

PATCHES=(
	"${FILESDIR}"/${P}-asneeded.patch
	"${FILESDIR}"/${P}-automake.patch
	"${FILESDIR}"/${P}-libpng15.patch
	"${FILESDIR}"/${P}-math-hack.patch
)

src_prepare() {
	default

	# https://sourceforge.net/apps/trac/speed-dreams/ticket/111
	MAKEOPTS="${MAKEOPTS} -j1"

	sed -i \
		-e '/ADDCFLAGS/s: -O2::' \
		configure.in || die
	sed -i \
		-e '/COPYING/s:=.*:= \\:' \
		Makefile || die
	sed -i \
		-e '/LDFLAGS/s:-L/usr/lib::' \
		-e "/^datadir/s:=.*:= /usr/share/games/${PN}:" \
		Make-config.in || die

	eautoreconf
}

src_configure() {
	addpredict $(echo /dev/snd/controlC? | sed 's/ /:/g')
	[[ -e /dev/dsp ]] && addpredict /dev/dsp
	econf \
		--prefix=/usr \
		--bindir=/usr/bin \
		$(use_enable xrandr)
}

src_install() {
	emake DESTDIR="${D}" install datainstall

	find "${D}" -name Makefile -exec rm -f {} +

	dodoc CHANGES README TODO

	newicon icon.svg ${PN}.svg
	make_desktop_entry ${PN} "Speed Dreams"
}
