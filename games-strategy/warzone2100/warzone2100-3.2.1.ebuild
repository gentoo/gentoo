# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools toolchain-funcs eutils versionator gnome2-utils

MY_PV=$(get_version_component_range -2)
VIDEOS_PV=2.2
VIDEOS_P=${PN}-videos-${VIDEOS_PV}.wz
DESCRIPTION="3D real-time strategy game"
HOMEPAGE="http://wz2100.net/"
SRC_URI="mirror://sourceforge/warzone2100/${P}.tar.xz
	videos? ( mirror://sourceforge/warzone2100/warzone2100/Videos/${VIDEOS_PV}/high-quality-en/sequences.wz -> ${VIDEOS_P} )"

# openssl-1.1.0 patches
SRC_URI+="
	https://github.com/Cyp/warzone2100/commit/d29cacac856882b153fa206c49091188af5d95aa.patch -> ${PN}-3.2.1-openssl110.patch
	https://github.com/Cyp/warzone2100/commit/efe8bf60ec56565b96a26b041a965c925bc58c3b.patch -> ${PN}-3.2.1-openssl110_v2.patch"

LICENSE="GPL-2+ CC-BY-SA-3.0 public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
# upstream requested debug support
IUSE="debug nls sdl videos"

# TODO: unbundle miniupnpc and quesoglc
# quesoglc-0.7.2 is buggy: http://developer.wz2100.net/ticket/2828
RDEPEND=">=dev-games/physfs-2[zip]
	dev-libs/fribidi
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtscript:5
	dev-qt/qtwidgets:5
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/glew:=
	media-libs/libogg
	media-libs/libpng:0
	media-libs/libtheora
	media-libs/libvorbis
	media-libs/openal
	sys-libs/zlib
	virtual/glu
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXrandr
	nls? ( virtual/libintl )
	!sdl? (
		dev-qt/qtopengl:5
		dev-qt/qtx11extras:5
	)
	sdl? ( media-libs/libsdl2[opengl,video,X] )"
DEPEND="${RDEPEND}
	app-arch/zip
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"
RDEPEND="${RDEPEND}
	media-fonts/dejavu"

PATCHES=(
	"${DISTDIR}/${P}-openssl110.patch"
	"${DISTDIR}/${P}-openssl110_v2.patch"
)

src_prepare() {
	default

	sed -i -e 's/#top_builddir/top_builddir/' po/Makevars || die
	sed '/appdata\.xml/d' -i icons/Makefile.am || die
	eautoreconf
}

src_configure() {
	econf \
		--docdir=/usr/share/doc/${PF} \
		--localedir=/usr/share/locale \
		--with-distributor="Gentoo ${PF}" \
		--with-icondir=/usr/share/icons/hicolor/128x128/apps \
		--with-applicationdir=/usr/share/applications \
		$(use_enable debug debug relaxed) \
		$(use_enable nls) \
		--with-backend=$(usex sdl "sdl" "qt")
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	default
	rm -f "${D}"/usr/share/doc/${PF}/COPYING*
	if use videos ; then
		insinto /usr/share/${PN}
		newins "${DISTDIR}"/${VIDEOS_P} sequences.wz
	fi
	doman doc/warzone2100.6
	dodoc doc/quickstartguide.pdf

	elog "If you are using opensource drivers you should consider installing: "
	elog "    media-libs/libtxc_dxtn"
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
