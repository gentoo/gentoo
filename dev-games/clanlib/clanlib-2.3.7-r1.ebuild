# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

MY_P=ClanLib-${PV}
DESCRIPTION="multi-platform game development library"
HOMEPAGE="http://www.clanlib.org/"
SRC_URI="http://clanlib.org/download/releases-2.0/${MY_P}.tgz"
S="${WORKDIR}"/${MY_P}

LICENSE="ZLIB"
SLOT="2.3"
# Not big endian safe! #82779
KEYWORDS="~amd64 ~x86"
IUSE="doc ipv6 mikmod opengl sound sqlite cpu_flags_x86_sse2 static-libs vorbis X"
REQUIRED_USE="opengl? ( X )"

BDEPEND="
	virtual/pkgconfig
	doc? ( app-doc/doxygen dev-lang/perl )
"
RDEPEND="
	sys-libs/zlib
	X? (
		app-arch/bzip2
		media-libs/libpng:0
		media-libs/freetype
		media-libs/fontconfig
		virtual/jpeg:0
		x11-libs/libX11
		opengl? ( virtual/opengl )
	)
	mikmod? (
		media-libs/alsa-lib
		media-libs/libmikmod
	)
	sqlite? ( dev-db/sqlite:3 )
	sound? ( media-libs/alsa-lib )
	vorbis? (
		media-libs/alsa-lib
		media-libs/libogg
		media-libs/libvorbis
	)
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-autotools.patch
	"${FILESDIR}"/${P}-doc.patch
	"${FILESDIR}"/${P}-freetype_pkgconfig.patch #764902
)

DOCS=( CODING_STYLE CREDITS PATCHES README )

src_prepare() {
	default

	eautoreconf

	ln -sf ../../../Sources/API Documentation/Utilities/ReferenceDocs/ClanLib || die
}

src_configure() {
	# Add -DPACKAGE_BUGREPORT?
	local myeconfargs=(
		$(use_enable doc docs)
		$(use_enable cpu_flags_x86_sse2 sse2)
		$(use_enable opengl clanGL)
		$(use_enable opengl clanGL1)
		$(use_enable opengl clanGUI)
		$(use_enable X clanDisplay)
		$(use_enable vorbis clanVorbis)
		$(use_enable mikmod clanMikMod)
		$(use_enable sqlite clanSqlite)
		$(use_enable ipv6 getaddr)
	)

	use sound \
		|| use vorbis \
		|| use mikmod \
		|| myeconfargs+=( --disable-clanSound )

	econf "${myeconfargs[@]}"
}

src_compile() {
	emake

	use doc && emake html
}

# html files are keeped in a directory that is dependent on the SLOT
# so to keep eventual bookmarks to the doc from version to version
src_install() {
	default

	if use doc ; then
		emake DESTDIR="${D}" install-html
		dodoc -r Examples Resources
	fi
}
