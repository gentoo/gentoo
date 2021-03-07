# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# TODO
# - attempt +test, linked bug claims to be fixed

EAPI=7

LUA_COMPAT=( lua5-{1..3} )
PYTHON_COMPAT=( python3_{7,8,9} )
VIRTUALX_REQUIRED="manual"
inherit desktop python-any-r1 eutils lua-single xdg-utils toolchain-funcs

MY_P="stone_soup-${PV}"
DESCRIPTION="Role-playing roguelike game of exploration and treasure-hunting in dungeons"
HOMEPAGE="https://crawl.develz.org"
SLOT="0.25"
SRC_URI="
	https://github.com/crawl/crawl/releases/download/${PV}/${PN/-/_}-${PV}.zip
	https://dev.gentoo.org/~stasibear/distfiles/${PN}.png -> ${PN}-${SLOT}.png
	https://dev.gentoo.org/~stasibear/distfiles/${PN}.svg -> ${PN}-${SLOT}.svg
"

# 3-clause BSD: mt19937ar.cc, MSVC/stdint.h
# 2-clause BSD: all contributions by Steve Noonan and Jesse Luehrs
# Public Domain|CC0: most of tiles
# MIT: json.cc/json.h, some .js files in webserver/static/scripts/contrib/
LICENSE="GPL-2 BSD BSD-2 public-domain CC0-1.0 MIT"
KEYWORDS="amd64 x86"
IUSE="debug ncurses sound test +tiles"
# test is broken
# see https://crawl.develz.org/mantis/view.php?id=6121
RESTRICT="test"

RDEPEND="
	${LUA_DEPS}
	dev-db/sqlite:3
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
	app-arch/unzip
	dev-lang/perl
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/pyyaml[${PYTHON_USEDEP}]')
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
	"${FILESDIR}"/fixed-font-path.patch
	"${FILESDIR}"/gitless-1.patch
	"${FILESDIR}"/rltiles-ldflags-libs.patch
)

python_check_deps() {
	has_version "dev-python/pyyaml[${PYTHON_USEDEP}]"
}

pkg_setup() {

	python-any-r1_pkg_setup

	if use !ncurses && use !tiles ; then
		ewarn "Neither ncurses nor tiles frontend"
		ewarn "selected, choosing ncurses only."
		ewarn "Note that you can also enable both."
	fi

	if use sound && use !tiles ; then
		ewarn "Sound support is only available with tiles."
	fi
}

src_prepare() {
	default
	python_fix_shebang "${S}/util/species-gen.py"

	sed -i -e "s/GAME = crawl$/GAME = crawl-${SLOT}/" "${S}/Makefile" \
		|| die "Couldn't append slot to executable name"
}

src_compile() {

	# Insurance that we're not using bundled lib sources
	rm -rf contrib || die "Couldn't delete contrib directory"

	export HOSTCXX=$(tc-getBUILD_CXX)

	# leave DATADIR at the top
	myemakeargs=(
		$(usex debug "FULLDEBUG=y DEBUG=y" "")
		BUILD_LUA=
		AR="$(tc-getAR)"
		CFOPTIMIZE=''
		CFOTHERS="${CXXFLAGS}"
		CONTRIBS=
		DATADIR="/usr/share/${PN}-${SLOT}"
		GCC="$(tc-getCC)"
		GXX="$(tc-getCXX)"
		LDFLAGS="${LDFLAGS}"
		MAKEOPTS="${MAKEOPTS}"
		PKGCONFIG="$(tc-getPKG_CONFIG)"
		RANLIB="$(tc-getRANLIB)"
		SAVEDIR="~/.crawl-${SLOT}"
		SOUND=$(usex sound "y" "")
		STRIP=touch
		USE_LUAJIT=
		V=1
		prefix="/usr"
	)

	if use ncurses || (use !ncurses && use !tiles) ; then
		emake "${myemakeargs[@]}"
		# move it in case we build both variants
		use tiles && { mv "crawl-${SLOT}" "${WORKDIR}"/crawl-ncurses-${SLOT} || die ;}
	fi

	if use tiles ; then
		emake clean
		emake "${myemakeargs[@]}" "TILES=y"
	fi
}

src_install() {
	emake "${myemakeargs[@]}" $(usex tiles "TILES=y" "") DESTDIR="${D}" prefix_fp="" bin_prefix="${D}/usr/bin" install
	[[ -e "${WORKDIR}/crawl-ncurses-${SLOT}" ]] && dobin "${WORKDIR}/crawl-ncurses-${SLOT}"

	# don't relocate docs, needed at runtime
	rm -rf "${D}/usr/share/${PN}-${SLOT}"/docs/license

	mv "${WORKDIR}/${MY_P}"/docs/crawl.6 "${WORKDIR}/${MY_P}/docs/crawl-${SLOT}.6" \
	   || die "Couldn't append slot to man page name"
	doman "${WORKDIR}/${MY_P}/docs/crawl-${SLOT}.6"

	# icons and menu for graphical build
	if use tiles ; then
		doicon -s 48 "${DISTDIR}"/${PN}-${SLOT}.png
		doicon -s scalable "${DISTDIR}"/${PN}-${SLOT}.svg
		make_desktop_entry "crawl-${SLOT}" "crawl-${SLOT}" "crawl-${SLOT}"
	fi
}

pkg_postinst() {
	xdg_icon_cache_update

	elog "Since version 0.25.1-r101, crawl is a slotted install"
	elog "that supports having multiple versions installed.  The"
	elog "binary has the slot appened, e.g. 'crawl-"${SLOT}"'."
	elog
	elog "The local save directory also has the slot appended."
	elog "If you have saved games from 0.25 but before 0.25.1-r101"
	elog "you can 'mv ~/.crawl ~/.crawl-0.25' to fix it"

	if use tiles && use ncurses ; then
		elog
		elog "Since you have enabled both tiles and ncurses frontends"
		elog "the ncurses binary is called 'crawl-ncurses-"${SLOT}"' and the"
		elog "tiles binary is called 'crawl-"${SLOT}"'."
	fi
}

pkg_postrm() {
	xdg_icon_cache_update
}
