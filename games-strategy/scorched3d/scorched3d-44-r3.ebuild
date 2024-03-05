# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"
inherit autotools desktop edos2unix flag-o-matic wxwidgets

DESCRIPTION="Multi-player tank battle in 3D (OpenGL)"
HOMEPAGE="http://www.scorched3d.co.uk/"
SRC_URI="mirror://sourceforge/scorched3d/Scorched3D-${PV}-src.tar.gz
	https://salsa.debian.org/games-team/scorched3d/-/raw/master/debian/scorched3d.png"
S="${WORKDIR}/scorched"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="dedicated mysql"

RDEPEND="
	dev-libs/expat
	media-fonts/dejavu
	media-libs/libpng:0=
	media-libs/libsdl[video]
	media-libs/sdl-net
	sys-libs/zlib
	x11-misc/xdg-utils
	virtual/jpeg:0
	!dedicated? (
		virtual/opengl
		virtual/glu
		media-libs/glew:0=
		media-libs/libogg
		media-libs/libvorbis
		media-libs/openal
		media-libs/freealut
		x11-libs/wxGTK:${WX_GTK_VER}[X]
		media-libs/freetype:2
		sci-libs/fftw:3.0=
	)
	mysql? ( dev-db/mysql-connector-c )
"
DEPEND="${RDEPEND}"
BDEPEND="!dedicated? ( virtual/pkgconfig )"

PATCHES=(
	"${FILESDIR}"/${P}-fixups.patch
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-odbc.patch
	"${FILESDIR}"/${P}-win32.patch
	"${FILESDIR}"/${P}-freetype.patch
	"${FILESDIR}"/${P}-jpeg9.patch
	"${FILESDIR}"/${P}-wxgtk.patch
	"${FILESDIR}"/${P}-fix-c++14.patch
	"${FILESDIR}"/${P}-help.patch
	"${FILESDIR}"/${P}-hang-fast-machines.patch
	"${FILESDIR}"/${P}-wxgtk32.patch
	"${FILESDIR}"/${P}-openal-pkgconfig.patch
)

src_prepare() {
	edos2unix \
		src/launcher/wxdialogs/SettingsDialog.cpp \
		src/launcher/wxdialogs/DisplayDialog.cpp \
		src/launcher/wxdialogs/Display.cpp \
		src/launcher/wxdialogs/KeyDialog.cpp
	default
	eautoreconf
}

src_configure() {
	# -Werror=odr
	# https://bugs.gentoo.org/859265
	# Upstream is inactive, latest activity from 9 years ago, sourceforge
	# project. Not filing a bug.
	filter-lto

	setup-wxwidgets
	econf \
		--datadir="${EPREFIX}"/usr/share/${PN} \
		--with-fftw="${EPREFIX}"/usr \
		--with-ogg="${EPREFIX}"/usr \
		--with-vorbis="${EPREFIX}"/usr \
		--with-docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--with-wx-config="${WX_CONFIG}" \
		--without-pgsql \
		$(use_with mysql) \
		$(use_enable dedicated serveronly)
}

src_install() {
	default

	# remove bundled fonts
	rm "${ED}"/usr/share/${PN}/data/fonts/* || die
	dosym ../../../fonts/dejavu/DejaVuSans.ttf /usr/share/${PN}/data/fonts/dejavusans.ttf
	dosym ../../../fonts/dejavu/DejaVuSansCondensed-Bold.ttf /usr/share/${PN}/data/fonts/dejavusconbd.ttf
	dosym ../../../fonts/dejavu/DejaVuSansMono-Bold.ttf /usr/share/${PN}/data/fonts/dejavusmobd.ttf

	if ! use dedicated; then
		doicon "${DISTDIR}"/${PN}.png
		make_desktop_entry ${PN} "Scorched 3D"
	fi
}
