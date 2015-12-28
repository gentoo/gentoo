# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils flag-o-matic games

LVL_PV="0.7.0" #they unfortunately don't release both at the same time, why ~ as separator :(
LVL="inksmoto-${LVL_PV}"
DESCRIPTION="A challenging 2D motocross platform game"
HOMEPAGE="http://xmoto.tuxfamily.org"
SRC_URI="http://download.tuxfamily.org/xmoto/xmoto/${PV}/${P}-src.tar.gz
	editor? ( http://download.tuxfamily.org/xmoto/svg2lvl/${LVL_PV}/${LVL}.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="editor nls"

RDEPEND="
	dev-libs/libxdg-basedir
	dev-db/sqlite:3
	dev-games/ode
	dev-lang/lua:0[deprecated]
	virtual/jpeg:0
	media-libs/libpng:0
	dev-libs/libxml2
	media-libs/libsdl[joystick,opengl]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-ttf
	media-libs/sdl-net
	net-misc/curl
	app-arch/bzip2
	virtual/opengl
	virtual/glu
	media-fonts/dejavu
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )"
RDEPEND="${RDEPEND}
	editor? ( media-gfx/inkscape )"

src_prepare() {
	use editor && rm -vf "${WORKDIR}"/extensions/{bezmisc,inkex}.py
	sed -i \
		-e '/^gettextsrcdir/s:=.*:= @localedir@/gettext/po:' \
		po/Makefile.in.in || die

	epatch "${FILESDIR}"/${P}-utf8.patch
}

src_configure() {
	# bug #289792
	filter-flags -DdDOUBLE
	has_version 'dev-games/ode[double-precision]' && append-flags -DdDOUBLE

	egamesconf \
		--enable-threads=posix \
		$(use_enable nls) \
		--localedir=/usr/share/locale \
		--with-localesdir=/usr/share/locale \
		--with-renderer-sdlGfx=0 \
		--with-renderer-openGl=1
}

src_install() {
	default

	rm -f "${D}${GAMES_DATADIR}/xmoto"/Textures/Fonts/DejaVu*.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSans.ttf "${GAMES_DATADIR}/xmoto"/Textures/Fonts/DejaVuSans.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSansMono.ttf "${GAMES_DATADIR}/xmoto"/Textures/Fonts/DejaVuSansMono.ttf
	doicon extra/xmoto.xpm
	make_desktop_entry xmoto Xmoto

	prepgamesdirs

	if use editor; then
		insinto /usr/share/inkscape/
		doins -r "${WORKDIR}"/extensions/
	fi
}

pkg_postinst() {
	games_pkg_postinst
	if use editor; then
		elog "If you want to know how to create Xmoto levels"
		elog "have a look at this Tutorial:"
		elog "    http://wiki.xmoto.tuxfamily.org/index.php?title=Inksmoto-${LVL_PV}"
		elog "You can share your levels on the Xmoto homepage."
	fi
}
