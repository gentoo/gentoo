# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-rpg/xu4/xu4-0.9.ebuild,v 1.14 2015/03/06 21:33:52 tupone Exp $

EAPI=5
inherit eutils games

DESCRIPTION="A remake of the computer game Ultima IV"
HOMEPAGE="http://xu4.sourceforge.net/"
SRC_URI="mirror://sourceforge/xu4/${P}.tar.gz
	mirror://sourceforge/xu4/ultima4-1.01.zip
	mirror://sourceforge/xu4/u4upgrad.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

RDEPEND="dev-libs/libxml2
	media-libs/sdl-mixer[timidity]
	media-libs/libsdl[sound,video]"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/u4

src_unpack() {
	# xu4 will read the data files right out of the zip files
	# but we want the docs from the original.
	unpack ${P}.tar.gz
	cp "${DISTDIR}"/{ultima4-1.01.zip,u4upgrad.zip} . || die
	cd "${WORKDIR}"
	mv ultima4-1.01.zip ultima4.zip
	mkdir u4-dos
	cd u4-dos
	unzip -q ../ultima4.zip || die
}

src_prepare() {
	epatch "${FILESDIR}/${PV}-savegame.patch" \
		"${FILESDIR}"/${P}-ldflags.patch \
		"${FILESDIR}"/${P}-zip.patch \
		"${FILESDIR}"/${P}-warnings.patch
	sed -i \
		-e "s:/usr/local/lib/u4:$(games_get_libdir)/u4:" src/u4file.c \
		|| die
	sed -i \
		-e 's:-Wall:$(E_CFLAGS):' src/Makefile \
		|| die
}

src_compile() {
	emake -C src \
		DEBUGCFLAGS= \
		E_CFLAGS="${CFLAGS}" \
		bindir="${GAMES_BINDIR}" \
		datadir="/usr/share" \
		libdir="$(games_get_libdir)"
}

src_install() {
	emake -C src \
		DEBUGCFLAGS= \
		E_CFLAGS="${CFLAGS}" \
		bindir="${D}${GAMES_BINDIR}" \
		datadir="${D}/usr/share" \
		libdir="${D}$(games_get_libdir)" \
		install
	dodoc AUTHORS README doc/*txt "${WORKDIR}/u4-dos/ULTIMA4/"*TXT
	insinto "$(games_get_libdir)/u4"
	doins "${WORKDIR}/"*zip
	prepgamesdirs
}
