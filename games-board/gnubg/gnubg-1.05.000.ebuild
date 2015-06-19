# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/games-board/gnubg/gnubg-1.05.000.ebuild,v 1.1 2015/06/13 04:12:18 mr_bones_ Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit eutils python-single-r1 gnome2-utils games

DESCRIPTION="GNU BackGammon"
HOMEPAGE="http://www.gnubg.org/"
SRC_URI="http://gnubg.org/media/sources/${PN}-release-${PV}-sources.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="cpu_flags_x86_avx gtk opengl python sqlite cpu_flags_x86_sse cpu_flags_x86_sse2 threads"

RDEPEND="dev-libs/glib:2
	media-libs/freetype:2
	media-libs/libpng:0
	x11-libs/cairo
	x11-libs/pango
	dev-db/sqlite:3
	media-libs/libcanberra
	dev-libs/libxml2
	dev-libs/gmp:0
	gtk? ( x11-libs/gtk+:2 )
	opengl? (
		x11-libs/gtk+:2
		x11-libs/gtkglext
		virtual/glu
	)
	sys-libs/readline:0
	python? ( ${PYTHON_DEPS} )
	media-fonts/dejavu
	virtual/libintl"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	sys-devel/gettext"

pkg_setup() {
	games_pkg_setup
	python-single-r1_pkg_setup
}

src_prepare() {
	# use ${T} instead of /tmp for constructing credits (bug #298275)
	sed -i -e 's:/tmp:${T}:' credits.sh || die
	sed -i -e 's/fonts //' Makefile.in || die # handle font install ourself to fix bug #335774
	sed -i \
		-e '/^localedir / s#=.*$#= @localedir@#' \
		-e '/^gnulocaledir / s#=.*$#= @localedir@#' \
		po/Makefile.in.in || die
	sed -i \
		-e '/^gnubgiconsdir / s#=.*#= /usr/share#' \
		-e '/^gnubgpixmapsdir / s#=.*#= /usr/share/pixmaps#' \
		pixmaps/Makefile.in || die
}

src_configure() {
	local simd=no
	local gtk_arg=--without-gtk

	if use gtk || use opengl ; then
		gtk_arg=--with-gtk
	fi
	use cpu_flags_x86_sse  && simd=sse
	use cpu_flags_x86_sse2 && simd=sse2
	use cpu_flags_x86_avx  && simd=avx
	egamesconf \
		--localedir=/usr/share/locale \
		--docdir=/usr/share/doc/${PF}/html \
		--disable-cputest \
		--enable-simd=${simd} \
		${gtk_arg} \
		$(use_enable threads) \
		$(use_with python) \
		$(use_with sqlite sqlite) \
		$(use_with opengl board3d)
}

src_install() {
	default
	insinto "${GAMES_DATADIR}/${PN}"
	doins ${PN}.weights *bd
	dodir "${GAMES_DATADIR}"/${PN}/fonts
	dosym /usr/share/fonts/dejavu/DejaVuSans.ttf "${GAMES_DATADIR}"/${PN}/fonts/Vera.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSans-Bold.ttf "${GAMES_DATADIR}"/${PN}/fonts/VeraBd.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSerif-Bold.ttf "${GAMES_DATADIR}"/${PN}/fonts/VeraSeBd.ttf
	make_desktop_entry "gnubg -w" "GNU Backgammon"
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
