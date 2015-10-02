# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

WX_GTK_VER="2.8"

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="threads,ssl"

inherit eutils wxwidgets toolchain-funcs gnome2-utils python-any-r1 games

MY_P=0ad-${PV/_/-}
DESCRIPTION="A free, real-time strategy game"
HOMEPAGE="http://play0ad.com/"
SRC_URI="mirror://sourceforge/zero-ad/${MY_P}-unix-build.tar.xz"

LICENSE="GPL-2 LGPL-2.1 MIT CC-BY-SA-3.0 ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="editor +lobby nvtt pch sound test"
RESTRICT="test"

RDEPEND="
	dev-libs/boost
	dev-libs/icu:=
	dev-libs/libxml2
	dev-libs/nspr
	~games-strategy/0ad-data-${PV}
	media-libs/libpng:0
	media-libs/libsdl2[X,opengl,video]
	net-libs/enet:1.3
	net-libs/miniupnpc:=
	net-misc/curl
	sys-libs/zlib
	virtual/jpeg:62
	virtual/opengl
	x11-libs/libX11
	x11-libs/libXcursor
	editor? ( x11-libs/wxGTK:${WX_GTK_VER}[X,opengl] )
	lobby? ( net-libs/gloox )
	nvtt? ( media-gfx/nvidia-texture-tools )
	sound? ( media-libs/libvorbis
		media-libs/openal )"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig
	test? ( dev-lang/perl )"

S=${WORKDIR}/${MY_P}

pkg_setup() {
	games_pkg_setup
	python-any-r1_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	epatch "${FILESDIR}"/${P}-miniupnpc14.patch
}

src_configure() {
	local myconf=(
		--with-system-nvtt
		--with-system-miniupnpc
		--minimal-flags
		--sdl2
		$(usex nvtt "" "--without-nvtt")
		$(usex pch "" "--without-pch")
		$(usex test "" "--without-tests")
		$(usex sound "" "--without-audio")
		$(usex editor "--atlas" "")
		$(usex lobby "" "--without-lobby")
		--collada
		--bindir="${GAMES_BINDIR}"
		--libdir="$(games_get_libdir)"/${PN}
		--datadir="${GAMES_DATADIR}"/${PN}
		)

	# stock premake4 does not work, use the shipped one
	emake -C "${S}"/build/premake/premake4/build/gmake.unix

	# regenerate scripts.c so our patch applies
	cd "${S}"/build/premake/premake4 || die
	"${S}"/build/premake/premake4/bin/release/premake4 embed || die

	# rebuild premake again... this is the most stupid build system
	emake -C "${S}"/build/premake/premake4/build/gmake.unix clean
	emake -C "${S}"/build/premake/premake4/build/gmake.unix

	# run premake to create build scripts
	cd "${S}"/build/premake || die
	"${S}"/build/premake/premake4/bin/release/premake4 \
		--file="premake4.lua" \
		--outpath="../workspaces/gcc/" \
		--platform=$(usex amd64 "x64" "x32") \
		--os=linux \
		"${myconf[@]}" \
		gmake || die "Premake failed"
}

src_compile() {
	tc-export AR

	# build bundled and patched spidermonkey
	cd libraries/source/spidermonkey || die
	JOBS="${MAKEOPTS}" ./build.sh || die
	cd "${S}" || die

	# build 3rd party fcollada
	emake -C libraries/source/fcollada/src

	# build 0ad
	emake -C build/workspaces/gcc verbose=1
}

src_test() {
	cd binaries/system || die
	./test -libdir "${S}/binaries/system" || die "test phase failed"
}

src_install() {
	newgamesbin binaries/system/pyrogenesis 0ad
	use editor && newgamesbin binaries/system/ActorEditor 0ad-ActorEditor

	insinto "${GAMES_DATADIR}"/${PN}
	doins -r binaries/data/l10n

	exeinto "$(games_get_libdir)"/${PN}
	doexe binaries/system/libCollada.so
	doexe libraries/source/spidermonkey/lib/*.so
	use editor && doexe binaries/system/libAtlasUI.so

	dodoc binaries/system/readme.txt
	doicon -s 128 build/resources/${PN}.png
	make_desktop_entry ${PN}

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	games_pkg_postinst
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
