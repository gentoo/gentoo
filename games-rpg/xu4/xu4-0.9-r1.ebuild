# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils

DESCRIPTION="A remake of the computer game Ultima IV"
HOMEPAGE="http://xu4.sourceforge.net/"
SRC_URI="mirror://sourceforge/xu4/${P}.tar.gz
	mirror://sourceforge/xu4/ultima4-1.01.zip
	mirror://sourceforge/xu4/u4upgrad.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="dev-libs/libxml2
	media-libs/libsdl[sound,video]
	media-libs/sdl-mixer[timidity]"
DEPEND="${RDEPEND}
	app-arch/unzip"

S=${WORKDIR}/u4

src_unpack() {
	# xu4 will read the data files right out of the zip files
	# but we want the docs from the original.
	unpack ${P}.tar.gz
	cp "${DISTDIR}"/{ultima4-1.01.zip,u4upgrad.zip} . || die
	cd "${WORKDIR}" || die
	mv ultima4-1.01.zip ultima4.zip || die
	mkdir u4-dos || die
	cd u4-dos || die
	unzip -q ../ultima4.zip || die
}

PATCHES=(
	"${FILESDIR}/${P}-ldflags.patch"
	"${FILESDIR}/${PV}-savegame.patch"
	"${FILESDIR}/${P}-warnings.patch"
	"${FILESDIR}/${P}-zip.patch"
)
src_prepare() {
	default

	sed -i \
		-e "s:/usr/local/lib/u4:/usr/$(get_libdir)/u4:" src/u4file.c \
		|| die
	sed -i \
		-e 's:-Wall:$(E_CFLAGS):' src/Makefile \
		|| die
}

src_compile() {
	emake -C src \
		DEBUGCFLAGS= \
		E_CFLAGS="${CFLAGS}" \
		bindir="/usr/bin" \
		datadir="/usr/share" \
		libdir="/usr/$(get_libdir)"
}

src_install() {
	emake -C src \
		DEBUGCFLAGS= \
		E_CFLAGS="${CFLAGS}" \
		bindir="${D}/usr/bin" \
		datadir="${D}/usr/share" \
		libdir="${D}/usr/$(get_libdir)" \
		install
	dodoc AUTHORS README doc/*txt "${WORKDIR}/u4-dos/ULTIMA4/"*TXT
	insinto "/usr/$(get_libdir)/u4"
	doins "${WORKDIR}/"*zip
}
