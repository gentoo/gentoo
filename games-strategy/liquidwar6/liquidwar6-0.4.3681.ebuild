# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-strategy/liquidwar6/liquidwar6-0.4.3681.ebuild,v 1.7 2015/01/26 17:41:27 mr_bones_ Exp $

EAPI=5

inherit autotools eutils toolchain-funcs games

MY_PV=${PV/_beta/beta}
MY_P=${PN}-${MY_PV}

DESCRIPTION="Unique multiplayer wargame between liquids"
HOMEPAGE="http://www.gnu.org/software/liquidwar6/"
SRC_URI="http://www.ufoot.org/download/liquidwar/v6/${MY_PV}/${MY_P}.tar.gz
	maps? ( http://www.ufoot.org/download/liquidwar/v6/${MY_PV}/${PN}-extra-maps-${MY_PV}.tar.gz )"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc gles2 gtk libcaca +maps nls +ogg openmp readline test"

# yes, cunit is rdep
# Drop the libtool dep once libltdl goes stable.
RDEPEND="dev-db/sqlite:3
	dev-libs/expat
	dev-scheme/guile
	dev-util/cunit
	media-libs/freetype:2
	media-libs/libpng:0
	media-libs/libsdl[X,opengl,video]
	media-libs/sdl-image[jpeg,png]
	media-libs/sdl-ttf
	net-misc/curl
	|| ( dev-libs/libltdl:0 <sys-devel/libtool-2.4.3-r2:2 )
	sys-libs/zlib
	virtual/glu
	virtual/jpeg
	virtual/opengl
	libcaca? ( media-libs/libcaca )
	gles2? ( media-libs/mesa[gles2] )
	gtk? ( x11-libs/gtk+:2 )
	nls? ( virtual/libintl
		virtual/libiconv )
	ogg? (
		media-libs/libsdl[X,sound,opengl,video]
		media-libs/sdl-mixer[vorbis]
	)
	readline? ( sys-libs/ncurses
		sys-libs/readline )"
DEPEND="${RDEPEND}
	dev-lang/perl
	nls? ( sys-devel/gettext )"

S=${WORKDIR}/${MY_P}
S_MAPS=${WORKDIR}/${PN}-extra-maps-${MY_PV}

pkg_setup() {
	if use openmp; then
		if [[ $(tc-getCC) == *gcc ]] && ! tc-has-openmp ; then
			ewarn "OpenMP is not available in your current selected gcc"
			die "need openmp capable gcc"
		fi
	fi
	games_pkg_setup
}

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-{ldconfig,paths}.patch \
		"${FILESDIR}"/${P}-check-headers.patch

	sed -i \
		-e 's/-Werror//' \
		configure.ac || die
	eautoreconf
}

src_configure() {
	# configure fails with cunit disabled
	egamesconf \
		$(use_enable nls) \
		--enable-cunit \
		$(use_enable gtk) \
		--enable-mod-gl1 \
		$(use_enable gles2 mod-gles2) \
		$(use_enable libcaca mod-caca) \
		$(use_enable openmp) \
		$(use_enable ogg mod-ogg) \
		$(use_enable !ogg silent) \
		$(use_enable readline console) \
		--disable-static \
		--datarootdir=/usr/share \
		--mandir=/usr/share/man \
		--docdir=/usr/share/doc/${PF} \
		--htmldir=/usr/share/doc/${PF}/html

	if use maps; then
		cd "${S_MAPS}" || die
		egamesconf
	fi
}

src_compile() {
	default
	use doc && emake html
	use maps && emake -C "${S_MAPS}"
}

src_install() {
	emake DESTDIR="${D}" install
	use maps && emake -C "${S_MAPS}" DESTDIR="${D}" install
	prune_libtool_files --all
	prepgamesdirs
}
