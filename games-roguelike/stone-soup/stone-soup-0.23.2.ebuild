# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO
# - attempt +test, linked bug claims to be fixed

EAPI=7
VIRTUALX_REQUIRED="manual"
inherit desktop eutils xdg-utils toolchain-funcs

MY_P="stone_soup-${PV}"
DESCRIPTION="Role-playing roguelike game of exploration and treasure-hunting in dungeons"
HOMEPAGE="http://crawl.develz.org/wordpress/"
SRC_URI="
	https://crawl.develz.org/release/$(ver_cut 1-2)/${PN/-/_}-${PV}.tar.xz
	https://dev.gentoo.org/~hasufell/distfiles/${PN}.png
	https://dev.gentoo.org/~hasufell/distfiles/${PN}.svg
"

# 3-clause BSD: mt19937ar.cc, MSVC/stdint.h
# 2-clause BSD: all contributions by Steve Noonan and Jesse Luehrs
# Public Domain|CC0: most of tiles
# MIT: json.cc/json.h, some .js files in webserver/static/scripts/contrib/
LICENSE="GPL-2 BSD BSD-2 public-domain CC0-1.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug ncurses sound test +tiles"
# test is broken
# see https://crawl.develz.org/mantis/view.php?id=6121
RESTRICT="test"

RDEPEND="
	dev-db/sqlite:3
	=dev-lang/lua-5.1*:0=
	sys-libs/zlib
	!ncurses? ( !tiles? ( sys-libs/ncurses:0 ) )
	ncurses? ( sys-libs/ncurses:0 )
	tiles? (
		media-fonts/dejavu
		media-libs/freetype:2
		media-libs/libpng:0
		sound? (
			   media-libs/libsdl2[X,opengl,sound,video]
			   media-libs/sdl2-mixer
		)
		!sound? ( media-libs/libsdl2[X,opengl,video] )
		media-libs/sdl2-image[png]
		virtual/glu
		virtual/opengl
	)"
DEPEND="${RDEPEND}
	dev-lang/perl
	dev-python/pyyaml
	sys-devel/flex
	tiles? (
		sys-libs/ncurses:0
	)
	virtual/pkgconfig
	virtual/yacc
	"

S=${WORKDIR}/${MY_P}/source
S_TEST=${WORKDIR}/${MY_P}_test/source
PATCHES=(
	"${FILESDIR}"/gitless.patch
	"${FILESDIR}"/pyyaml-safe-load.patch
	"${FILESDIR}"/rltiles-ldflags-libs.patch
)

pkg_setup() {
	if use !ncurses && use !tiles ; then
		ewarn "Neither ncurses nor tiles frontend"
		ewarn "selected, choosing ncurses only."
		ewarn "Note that you can also enable both."
	fi

	if use sound && use !tiles ; then
		ewarn "Sound support is only available with tiles."
	fi
}

src_compile() {
	export HOSTCXX=$(tc-getBUILD_CXX)

	# leave DATADIR at the top
	myemakeargs=(
		$(usex debug "FULLDEBUG=y DEBUG=y" "")
		BUILD_LUA=
		AR="$(tc-getAR)"
		CFOPTIMIZE=''
		CFOTHERS="${CXXFLAGS}"
		CONTRIBS=
		DATADIR="/usr/share/${PN}"
		GCC="$(tc-getCC)"
		GXX="$(tc-getCXX)"
		LDFLAGS="${LDFLAGS}"
		MAKEOPTS="${MAKEOPTS}"
		PKGCONFIG="$(tc-getPKG_CONFIG)"
		RANLIB="$(tc-getRANLIB)"
		SAVEDIR="~/.crawl"
		SOUND=$(usex sound "y" "")
		STRIP=touch
		USE_LUAJIT=
		V=1
		prefix="/usr"
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

	doman "${WORKDIR}/${MY_P}"/docs/crawl.6

	# icons and menu for graphical build
	if use tiles ; then
		doicon -s 48 "${DISTDIR}"/${PN}.png
		doicon -s scalable "${DISTDIR}"/${PN}.svg
		make_desktop_entry crawl
	fi
}

pkg_postinst() {
	xdg_icon_cache_update

	if use tiles && use ncurses ; then
		elog "Since you have enabled both tiles and ncurses frontends"
		elog "the ncurses binary is called 'crawl-ncurses' and the"
		elog "tiles binary is called 'crawl'."
	fi
}

pkg_postrm() {
	xdg_icon_cache_update
}
