# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="OpenSource 2D MMORPG client for Evol Online and The Mana World"
HOMEPAGE="https://manaplus.org"
if [[ ${PV} == 9999 ]] ; then
	inherit autotools git-r3
	EGIT_REPO_URI="https://gitlab.com/manaplus/manaplus.git"
else
	SRC_URI="http://download.evolonline.org/manaplus/download/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2+"
SLOT="0"
IUSE="mumble nls opengl pugixml +sdl2 test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-games/physfs-1.0.0
	media-fonts/dejavu
	media-fonts/liberation-fonts
	media-fonts/mplus-outline-fonts
	media-fonts/wqy-microhei
	media-libs/libpng:0=
	net-misc/curl
	sys-libs/zlib
	x11-apps/xmessage
	x11-libs/libX11
	x11-misc/xdg-utils
	mumble? ( net-voip/mumble )
	nls? ( virtual/libintl )
	opengl? ( virtual/opengl )
	pugixml? ( dev-libs/pugixml )
	!pugixml? ( dev-libs/libxml2:= )
	sdl2? (
		media-libs/libsdl2[X,opengl?,video]
		media-libs/sdl2-gfx
		media-libs/sdl2-image[png]
		media-libs/sdl2-mixer[vorbis]
		media-libs/sdl2-net
		media-libs/sdl2-ttf
	)
	!sdl2? (
		media-libs/libsdl[X,opengl?,video]
		media-libs/sdl-gfx
		media-libs/sdl-image[png]
		media-libs/sdl-mixer[vorbis]
		media-libs/sdl-net
		media-libs/sdl-ttf
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	nls? ( sys-devel/gettext )"

src_prepare() {
	default

	if [[ ${PV} == 9999 ]] ; then
		eautoreconf
	fi
}

src_configure() {
	local myeconfargs=(
		--localedir="${EPREFIX}/usr/share/locale"
		--without-internalsdlgfx
		$(use_with mumble)
		$(use_enable nls)
		$(use_with opengl)
		--enable-libxml=$(usex pugixml pugixml libxml)
		$(use_with sdl2)
		$(use_enable test unittests)
	)

	CONFIG_SHELL="${BROOT}/bin/bash" econf "${myeconfargs[@]}"
}

src_install() {
	default

	local srcpath="../../../fonts"
	local destpath="/usr/share/${PN}/data/fonts"
	dosym ${srcpath}/dejavu/DejaVuSans-Bold.ttf "${destpath}"/dejavusans-bold.ttf
	dosym ${srcpath}/dejavu/DejaVuSans.ttf "${destpath}"/dejavusans.ttf
	dosym ${srcpath}/dejavu/DejaVuSansMono-Bold.ttf "${destpath}"/dejavusansmono-bold.ttf
	dosym ${srcpath}/dejavu/DejaVuSansMono.ttf "${destpath}"/dejavusansmono.ttf
	dosym ${srcpath}/dejavu/DejaVuSerifCondensed-Bold.ttf "${destpath}"/dejavuserifcondensed-bold.ttf
	dosym ${srcpath}/dejavu/DejaVuSerifCondensed.ttf "${destpath}"/dejavuserifcondensed.ttf
	dosym ${srcpath}/liberation-fonts/LiberationMono-Bold.ttf "${destpath}"/liberationsansmono-bold.ttf
	dosym ${srcpath}/liberation-fonts/LiberationMono-Regular.ttf "${destpath}"/liberationsansmono.ttf
	dosym ${srcpath}/liberation-fonts/LiberationSans-Bold.ttf "${destpath}"/liberationsans-bold.ttf
	dosym ${srcpath}/liberation-fonts/LiberationSans-Regular.ttf "${destpath}"/liberationsans.ttf
	dosym ${srcpath}/mplus-outline-fonts/mplus-1p-bold.ttf "${destpath}"/mplus-1p-bold.ttf
	dosym ${srcpath}/mplus-outline-fonts/mplus-1p-regular.ttf "${destpath}"/mplus-1p-regular.ttf
	dosym ${srcpath}/wqy-microhei/wqy-microhei.ttc "${destpath}"/wqy-microhei.ttf
}
