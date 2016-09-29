# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit autotools eutils flag-o-matic

LVL_PV="0.7.0" #they unfortunately don't release both at the same time, why ~ as separator :(
LVL="inksmoto-${LVL_PV}"
DEB_PV=6
DESCRIPTION="A challenging 2D motocross platform game"
HOMEPAGE="http://xmoto.tuxfamily.org"
SRC_URI="http://download.tuxfamily.org/xmoto/xmoto/${PV}/${P}-src.tar.gz
	mirror://debian/pool/main/x/${PN}/${PN}_${PV}+dfsg-${DEB_PV}.debian.tar.xz
	editor? ( http://download.tuxfamily.org/xmoto/svg2lvl/${LVL_PV}/${LVL}.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="editor nls"

RDEPEND="
	app-arch/bzip2
	dev-db/sqlite:3
	dev-games/ode
	dev-lang/lua:0[deprecated]
	dev-libs/libxdg-basedir
	dev-libs/libxml2
	media-fonts/dejavu
	media-libs/libpng:0
	media-libs/libsdl[joystick,opengl]
	media-libs/sdl-mixer[vorbis]
	media-libs/sdl-net
	media-libs/sdl-ttf
	net-misc/curl
	virtual/jpeg:0
	virtual/opengl
	virtual/glu
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	nls? ( sys-devel/gettext )"
RDEPEND="${RDEPEND}
	editor? ( media-gfx/inkscape )"

src_prepare() {
	default

	EPATCH_SOURCE="${WORKDIR}/debian/patches" \
		epatch $(cat ${WORKDIR}/debian/patches/series)
	use editor && rm -vf "${WORKDIR}"/extensions/{bezmisc,inkex}.py
	sed -i \
		-e '/^gettextsrcdir/s:=.*:= @localedir@/gettext/po:' \
		po/Makefile.in.in || die
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	# bug #289792
	filter-flags -DdDOUBLE -DdSINGLE

	# bug #569624 - ode-0.13 needs one or the other defined
	append-cppflags -Dd$(has_version 'dev-games/ode[double-precision]' && echo DOUBLE || echo SINGLE)

	econf \
		--enable-threads=posix \
		$(use_enable nls) \
		--localedir=/usr/share/locale \
		--with-localesdir=/usr/share/locale \
		--with-renderer-sdlGfx=0 \
		--with-renderer-openGl=1
}

src_install() {
	default

	rm -f "${D}/usr/share/xmoto"/Textures/Fonts/DejaVu*.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSans.ttf /usr/share/xmoto/Textures/Fonts/DejaVuSans.ttf
	dosym /usr/share/fonts/dejavu/DejaVuSansMono.ttf /usr/share/xmoto/Textures/Fonts/DejaVuSansMono.ttf
	doicon extra/xmoto.xpm
	make_desktop_entry xmoto Xmoto

	if use editor; then
		insinto /usr/share/inkscape/
		doins -r "${WORKDIR}"/extensions/
	fi
}

pkg_postinst() {
	if use editor; then
		elog "If you want to know how to create Xmoto levels"
		elog "have a look at this Tutorial:"
		elog "    http://wiki.xmoto.tuxfamily.org/index.php?title=Inksmoto-${LVL_PV}"
		elog "You can share your levels on the Xmoto homepage."
	fi
}
