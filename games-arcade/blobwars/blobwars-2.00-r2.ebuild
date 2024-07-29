# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit xdg

DESCRIPTION="Platform game about a blob and his quest to rescue MIAs from an alien invader"
HOMEPAGE="https://sourceforge.net/projects/blobwars/ https://www.parallelrealities.co.uk/games/metalBlobSolid/ https://github.com/perpendicular-dimensions/blobwars"
SRC_URI="https://downloads.sourceforge.net/blobwars/${P}.tar.gz"

LICENSE="BSD CC-BY-SA-3.0 CC-BY-3.0 GPL-2 LGPL-2.1 fairuse public-domain"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	media-libs/libsdl2
	media-libs/sdl2-mixer
	media-libs/sdl2-ttf
	media-libs/sdl2-image
	media-libs/sdl2-net
	sys-libs/zlib
	virtual/libintl
"
DEPEND="${RDEPEND}"
BDEPEND="sys-devel/gettext"

PATCHES=(
	# Stop providing/overriding strlcat and strlcpy to fix bug #831671
	"${FILESDIR}"/${P}-dont-override-strlcat.patch

	"${FILESDIR}"/${P}-generic-name.patch
	"${FILESDIR}"/${P}-time_t.patch
)

src_prepare() {
	default

	# Fixes from Fedora and OpenSuSE
	sed -i -e 's|$(PREFIX)/games|$(PREFIX)/bin|;
		s|$(PREFIX)/share/games|$(PREFIX)/share|;
		s| -Werror||;
		s|$(CXX) $(LIBS) $(GAMEOBJS) -o $(PROG)|$(CXX) $(GAMEOBJS) $(LIBS) -o $(PROG)|;
		s|$(CXX) $(LIBS) $(PAKOBJS) -o pak|$(CXX) $(PAKOBJS) $(LIBS) -o pak|;
		s|$(CXX) $(LIBS) $(MAPOBJS) -o mapeditor|$(CXX) $(MAPOBJS) $(LIBS) -o mapeditor|' \
		Makefile || die
	sed -i -e 's|gzclose(pak)|gzclose((gzFile)pak)|;
		s|gzclose(fp)|gzclose((gzFile)fp)|' src/pak.cpp || die
}

src_compile() {
	# USEPAK=1 breaks music
	emake \
		RELEASE="1" \
		USEPAK="0"
}

src_install() {
	emake \
		BINDIR="/usr/bin/" \
		USEPAK="0" \
		DESTDIR="${D}" \
		DOCDIR="/usr/share/doc/${PF}/html/" \
		install

	mv -vf \
		"${D}"/usr/share/doc/${PF}/html/{changes,hacking,porting,readme} \
		"${D}"/usr/share/doc/${PF}/

	insinto /usr/share/metainfo
	doins "${FILESDIR}"/${PN}.appdata.xml
}
