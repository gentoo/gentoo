# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A remake of the computer game Ultima IV"
HOMEPAGE="https://xu4.sourceforge.net/"
SRC_URI="https://github.com/xu4-engine/u4/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz
	https://ultima.thatfleminggent.com/ultima4.zip
	https://downloads.sourceforge.net/xu4/u4upgrad.zip"
S="${WORKDIR}/u4-${PV}/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/boron
	media-libs/allegro:5[opengl]
	media-libs/faun
	media-libs/libglvnd
	media-libs/libpng:=
	sys-libs/zlib:=[minizip]
"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}/1.2.1-system-minizip.patch"
	"${FILESDIR}/1.2.1-desktop-file.patch"
)

src_unpack() {
	# xu4 will read the data files right out of the zip files
	# but we want the docs from the original.
	unpack ${P}.gh.tar.gz
	unpack ultima4.zip
	# Place zips where make install expects them
	cp "${DISTDIR}/ultima4.zip" "${DISTDIR}/u4upgrad.zip" "${S}" || die
}

src_prepare() {
	default

	# rm as part of using system minizip patch
	rm -f src/unzip.{c,h} || die
	sed -i -e '/CXXFLAGS+=-O3 -DNDEBUG/d' src/Makefile || die
	# Don't strip executable
	sed -i -e 's:-s src/xu4:src/xu4:g' Makefile || die
}

src_configure() {
	# custom configure
	./configure --allegro || die
}

src_install() {
	emake DESTDIR="${D}/usr" install
	dodoc AUTHORS README.md doc/*.txt "${WORKDIR}"/*.txt
	insinto "/usr/share/xu4"
	doins "${DISTDIR}/ultima4.zip"
}
