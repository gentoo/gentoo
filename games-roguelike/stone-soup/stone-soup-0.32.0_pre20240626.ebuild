# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# There are many slots for this package because people in the community
# like to play old versions.  Every release includes content changes
# where species/spells/monsters are added or removed.  The public
# servers (e.g. http://crawl.akrasiac.org:8080) usually support playing
# versions back to 0.11.

# It's not necessary for Gentoo to support these old version but it's
# something nice that our distro can offer that others don't.  If the
# maintenance burden becomes excessive than we can revisit that
# position.

EAPI=8

LUA_COMPAT=( lua5-1 )
LUA_REQ_USE="deprecated"
PYTHON_COMPAT=( python3_{10,11,12,13} )
VIRTUALX_REQUIRED="manual"
inherit desktop python-any-r1 lua-single xdg-utils toolchain-funcs

DESCRIPTION="Role-playing roguelike game of exploration and treasure-hunting in dungeons"
HOMEPAGE="https://crawl.develz.org"

# Leave empty string if not a _pre release
COMMITSHA="3d6ac616a9d452a692b94beb1a9d6b8e66346631"
if [ -z "${COMMITSHA}" ]; then
	# This is a tagged release
	# Note the archive URI and file layout changed upstream between 0.29.0 and 0.29.1
	SRC_URI="
		https://github.com/crawl/crawl/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	"
	MY_P="crawl-${PV}/crawl-ref"
else
	# This is a _pre release
	SRC_URI="
		https://github.com/crawl/crawl/archive/${COMMITSHA}.tar.gz -> ${P}.tar.gz
	"
	MY_P="crawl-${COMMITSHA}/crawl-ref"
fi
# MY_SLOT to satisfy pkgcheck variable order checking
MY_SLOT="0.32"
SRC_URI="
	${SRC_URI}
	https://dev.gentoo.org/~stasibear/distfiles/${PN}.png -> ${PN}-${MY_SLOT}.png
	https://dev.gentoo.org/~stasibear/distfiles/${PN}.svg -> ${PN}-${MY_SLOT}.svg
"

S=${WORKDIR}/${MY_P}/source
# 3-clause BSD: mt19937ar.cc, MSVC/stdint.h
# 2-clause BSD: all contributions by Steve Noonan and Jesse Luehrs
# Public Domain|CC0: most of tiles
# MIT: json.cc/json.h, some .js files in webserver/static/scripts/contrib/
LICENSE="GPL-2 BSD BSD-2 public-domain CC0-1.0 MIT"
SLOT="${MY_SLOT}"
KEYWORDS="~amd64 ~x86"
IUSE="advpng debug ncurses sound test +tiles"
RESTRICT="!test? ( test )"
REQUIRED_USE="${LUA_REQUIRED_USE}"

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
	test? ( <dev-cpp/catch-3.0.0:0 )
	tiles? (
		sys-libs/ncurses:0
	)
	"
BDEPEND="
	app-arch/unzip
	dev-lang/perl
	${PYTHON_DEPS}
	$(python_gen_any_dep 'dev-python/pyyaml[${PYTHON_USEDEP}]')
	app-alternatives/lex
	tiles? (
		advpng? (
			app-arch/advancecomp
		)
		!advpng? (
			media-gfx/pngcrush
		)
	)
	virtual/pkgconfig
	app-alternatives/yacc
	"

PATCHES=(
	"${FILESDIR}"/make-v3.patch
	"${FILESDIR}"/rltiles-make.patch
	"${FILESDIR}"/avoid-musl-execinfo.patch
)

python_check_deps() {
	python_has_version "dev-python/pyyaml[${PYTHON_USEDEP}]"
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

	if use advpng; then
		eapply "${FILESDIR}/make-advpng.patch"
	fi

	sed -i -e "s/GAME = crawl$/GAME = crawl-${SLOT}/" "${S}/Makefile" \
		|| die "Couldn't append slot to executable name"

	# File required for a _pre build
	if ! [ -f "${S}/util/release_ver" ]; then
		echo "${SLOT}" >"${S}/util/release_ver" || die "Couldn't write release_ver"
	fi

	# Replace bundled catch2 package with system implementation
	# https://bugs.gentoo.org/829950
	if use test; then
		cp /usr/include/catch2/catch.hpp "${S}/catch2-tests" || die "Couldn't substitute system catch2"
	fi
}

src_compile() {

	# Insurance that we're not using bundled lib sources
	rm -rf contrib || die "Couldn't delete contrib directory"

	myemakeargs=(
		$(usex debug "FULLDEBUG=y DEBUG=y" "")
		BUILD_LUA=
		AR="$(tc-getAR)"
		CFOPTIMIZE=''
		# -DLUA_COMPAT_OPENLIB=1 is required to enable the
		# deprecated (in 5.1) luaL_openlib API (#869671)
		CFOTHERS="${CXXFLAGS} -DLUA_COMPAT_OPENLIB=1"
		CONTRIBS=
		DATADIR="/usr/share/${PN}-${SLOT}"
		FORCE_CC="$(tc-getCC)"
		FORCE_CXX="$(tc-getCXX)"
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
		emake "${myemakeargs[@]}" clean
		emake "${myemakeargs[@]}" "TILES=y"
	fi
}

src_test() {
	emake "${myemakeargs[@]}" \
		  $(usex tiles "TILES=y" "") \
		  catch2-tests
}

src_install() {
	emake "${myemakeargs[@]}" \
		  $(usex tiles "TILES=y" "") \
		  DESTDIR="${D}" \
		  prefix_fp="" \
		  bin_prefix="${D}/usr/bin" \
		  install

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

	elog "crawl is a slotted install that supports having"
	elog "multiple versions installed.  The binary has the"
	elog "slot appended, e.g. 'crawl-"${SLOT}"'."

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
