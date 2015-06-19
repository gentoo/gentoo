# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-roguelike/stone-soup/stone-soup-0.16.1.ebuild,v 1.1 2015/05/14 10:28:09 hasufell Exp $

## TODO
# add sound support (no sound files)

EAPI=5
VIRTUALX_REQUIRED="manual"
inherit eutils gnome2-utils virtualx toolchain-funcs games

MY_P="stone_soup-${PV}"
DESCRIPTION="Dungeon Crawl Stone Soup is a role-playing roguelike game of exploration and treasure-hunting in dungeons"
HOMEPAGE="http://crawl.develz.org/wordpress/"
SRC_URI="https://crawl.develz.org/release/stone_soup-${PV}.tar.xz
	http://dev.gentoo.org/~hasufell/distfiles/${PN}.png
	http://dev.gentoo.org/~hasufell/distfiles/${PN}.svg"

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
	!ncurses? ( !tiles? ( sys-libs/ncurses ) )
	ncurses? ( sys-libs/ncurses )
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
		sys-libs/ncurses
		test? ( ${VIRTUALX_DEPEND} )
	)"

S=${WORKDIR}/${MY_P}/source
S_TEST=${WORKDIR}/${MY_P}_test/source

pkg_setup() {
	games_pkg_setup
	if use !ncurses && use !tiles ; then
		ewarn "Neither ncurses nor tiles frontend"
		ewarn "selected, choosing ncurses only."
		ewarn "Note that you can also enable both."
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-respect-flags-and-compiler.patch \
		"${FILESDIR}"/${P}-Use-pkg-config-for-linking-to-ncurses.patch

	rm -r contrib/{fonts,freetype,libpng,pcre,sdl2,sdl2-image,sdl2-mixer,sqlite,zlib} || die

#	if use test ; then
#		cp -av "${WORKDIR}/${MY_P}" "${WORKDIR}/${MY_P}_test" \
#			|| die "setting up test-dir failed"
#	fi
}

src_compile() {
	export HOSTCXX=$(tc-getBUILD_CXX)

	# leave DATADIR at the top
	myemakeargs=(
		$(usex luajit "" "BUILD_LUA=yes") # luajit is not bundled
		USE_LUAJIT=$(usex luajit "yes" "")
		DATADIR="${GAMES_DATADIR}/${PN}"
		V=1
		prefix="${GAMES_PREFIX}"
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

	# for test to work we need to compile with unset DATADIR
#	if use test ; then
#		emake ${myemakeargs[@]:1} -C "${S_TEST}"
#	fi
}

src_install() {
	emake "${myemakeargs[@]}" $(usex tiles "TILES=y" "") DESTDIR="${D}" prefix_fp="" bin_prefix="${D}${GAMES_BINDIR}" install
	[[ -e "${WORKDIR}"/crawl-ncurses ]] && dogamesbin "${WORKDIR}"/crawl-ncurses

	# don't relocate docs, needed at runtime
	rm -rf "${D}${GAMES_DATADIR}"/${PN}/docs/license
	dodoc "${WORKDIR}"/${MY_P}/README.{txt,pdf}

	# icons and menu for graphical build
	if use tiles ; then
		doicon -s 48 "${DISTDIR}"/${PN}.png
		doicon -s scalable "${DISTDIR}"/${PN}.svg
		make_desktop_entry crawl
	fi

	prepgamesdirs
}

src_test() {
	$(usex tiles "X" "")emake "${myemakeargs[@]:1}" -C "${S_TEST}" test
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
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
