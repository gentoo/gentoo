# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

DESCRIPTION="You control a psychic bodyguard, and try to protect the VIP"
HOMEPAGE="http://www.wolfire.com/blackshades.html
	http://www.icculus.org/blackshades/"
SRC_URI="http://filesingularity.timedoctor.org/Textures.tar.bz2
	mirror://gentoo/${P}.tar.bz2"

LICENSE="blackshades"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	media-libs/freealut
	media-libs/libsdl
	media-libs/libvorbis
	media-libs/openal
	virtual/glu
	virtual/opengl"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

PATCHES=(
	"${FILESDIR}"/${PN}-datadir.patch
)

src_prepare() {
	default

	rm -rf Data/Textures || die
	rm -f ../Textures/{,Blood/}._* || die
	mv -f ../Textures Data || die "mv failed"
	sed -i \
		-e "s/-O2 \(-Wall\) -g/${CXXFLAGS} \1/" \
		-e "/^LINKER/s:$: ${LDFLAGS}:" \
		Makefile \
		|| die "sed Makefile failed"
	sed -i "s:@DATADIR@:/usr/share/${PN}:" \
		Source/Main.cpp \
		|| die "sed Main.cpp failed"
}

src_compile() {
	emake bindir
	emake
}

src_install() {
	newbin objs/blackshades ${PN}
	insinto /usr/share/${PN}
	doins -r Data
	dodoc IF_THIS_IS_A_README_YOU_HAVE_WON Readme TODO uDevGame_Readme
	make_desktop_entry ${PN} "Black Shades"
}
