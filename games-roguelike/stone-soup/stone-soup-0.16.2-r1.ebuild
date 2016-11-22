# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

## TODO
# add sound support (no sound files)

EAPI=6
VIRTUALX_REQUIRED="manual"
inherit eutils gnome2-utils toolchain-funcs

MY_P="stone_soup-${PV}"
DESCRIPTION="Dungeon Crawl Stone Soup is a role-playing roguelike game of exploration and treasure-hunting in dungeons"
HOMEPAGE="http://crawl.develz.org/wordpress/"
SRC_URI="https://crawl.develz.org/release/stone_soup-${PV}.tar.xz
	https://dev.gentoo.org/~hasufell/distfiles/${PN}.png
	https://dev.gentoo.org/~hasufell/distfiles/${PN}.svg"

# 3-clause BSD: mt19937ar.cc, MSVC/stdint.h
# 2-clause BSD: all contributions by Steve Noonan and Jesse Luehrs
# Public Domain|CC0: most of tiles
# MIT: json.cc/json.h, some .js files in webserver/static/scripts/contrib/
LICENSE="GPL-2 BSD BSD-2 public-domain CC0-1.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug luajit ncurses test +tiles"
# test is broken
# see https://crawl.develz.org/mantis/view.php?id=6121
RESTRICT="test"

RDEPEND="
	dev-db/sqlite:3
	luajit? ( >=dev-lang/luajit-2.0.0 )
	sys-libs/zlib
	!ncurses? ( !tiles? ( sys-libs/ncurses:0 ) )
	ncurses? ( sys-libs/ncurses:0 )
	tiles? (
		media-fonts/dejavu
		media-libs/freetype:2
		media-libs/libpng:0
		media-libs/libsdl2[opengl,video]
		media-libs/sdl2-image[png]
		virtual/glu
		virtual/opengl
	)"
DEPEND="${RDEPEND}
	dev-lang/perl
	sys-devel/flex
	virtual/pkgconfig
	virtual/yacc
	tiles? (
		sys-libs/ncurses:0
	)"

S=${WORKDIR}/${MY_P}/source
S_TEST=${WORKDIR}/${MY_P}_test/source

PATCHES=(
	"${FILESDIR}"/${P}-respect-flags-and-compiler.patch
	"${FILESDIR}"/${P}-Use-pkg-config-for-linking-to-ncurses.patch
)

pkg_setup() {
	if use !ncurses && use !tiles ; then
		ewarn "Neither ncurses nor tiles frontend"
		ewarn "selected, choosing ncurses only."
		ewarn "Note that you can also enable both."
	fi
}

src_prepare() {
	default

	rm -r contrib/{fonts,freetype,libpng,pcre,sdl2,sdl2-image,sdl2-mixer,sqlite,zlib} || die
}

src_compile() {
	export HOSTCXX=$(tc-getBUILD_CXX)

	# leave DATADIR at the top
	myemakeargs=(
		$(usex luajit "" "BUILD_LUA=yes") # luajit is not bundled
		USE_LUAJIT=$(usex luajit "yes" "")
		DATADIR="/usr/share/${PN}"
		V=1
		prefix="/usr"
		SAVEDIR="~/.crawl"
		$(usex debug "FULLDEBUG=y DEBUG=y" "")
		CFOPTIMIZE="${CXXFLAGS}"
		LDFLAGS="${LDFLAGS}"
		MAKEOPTS="${MAKEOPTS}"
		AR="$(tc-getAR)"
		RANLIB="$(tc-getRANLIB)"
		CC="$(tc-getCC)"
		CXX="$(tc-getCXX)"
		PKGCONFIG="$(tc-getPKG_CONFIG)"
		STRIP=touch
	)

	if use ncurses || (use !ncurses && use !tiles) ; then
		emake "${myemakeargs[@]}"
		# move it in case we build both variants
		use tiles && { mv crawl "${WORKDIR}"/crawl-ncurses || die ;}
	fi

	if use tiles ; then
		emake clean
		emake "${myemakeargs[@]}" "TILES=y"
	fi
}

src_install() {
	emake "${myemakeargs[@]}" $(usex tiles "TILES=y" "") DESTDIR="${D}" prefix_fp="" bin_prefix="${D}/usr/bin" install
	[[ -e "${WORKDIR}"/crawl-ncurses ]] && dobin "${WORKDIR}"/crawl-ncurses

	# don't relocate docs, needed at runtime
	rm -rf "${D}/usr/share/${PN}"/docs/license
	dodoc "${WORKDIR}"/${MY_P}/README.{txt,pdf}

	# icons and menu for graphical build
	if use tiles ; then
		doicon -s 48 "${DISTDIR}"/${PN}.png
		doicon -s scalable "${DISTDIR}"/${PN}.svg
		make_desktop_entry crawl
	fi
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update

	if use tiles && use ncurses ; then
		elog "Since you have enabled both tiles and ncurses frontends"
		elog "the ncurses binary is called 'crawl-ncurses' and the"
		elog "tiles binary is called 'crawl'."
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
