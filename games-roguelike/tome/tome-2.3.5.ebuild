# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_PV=${PV//./}
DESCRIPTION="save the world from Morgoth and battle evil (or become evil ;])"
HOMEPAGE="http://t-o-m-e.net/"
SRC_URI="http://t-o-m-e.net/dl/src/tome-${MY_PV}-src.tar.bz2"
S="${WORKDIR}"/tome-${MY_PV}-src/src

LICENSE="Moria"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gtk sdl X Xaw3d"

RDEPEND="
	>=sys-libs/ncurses-5:0=
	sdl? (
		media-libs/sdl-ttf
		media-libs/sdl-image
		media-libs/libsdl )
	gtk? ( >=x11-libs/gtk+-2.12.8:2 )
	X? ( x11-libs/libX11 )
	Xaw3d? ( x11-libs/libXaw )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	x11-misc/makedepend
"

RDEPEND+=" acct-group/gamestat"

PATCHES=(
	"${FILESDIR}/"${PN}-2.3.5-gentoo-paths.patch
	"${FILESDIR}"/${PN}-2.3.5-format.patch
	"${FILESDIR}"/${PN}-2.3.5-noX.patch
)

src_prepare() {
	mv makefile.std makefile || die

	default

	sed -i -e '/^CC =/d' makefile || die
	sed -i -e "s:xx:x:" ../lib/edit/p_info.txt || die
	# sed -i -e "s:GENTOO_DIR:${GAMES_STATEDIR}:" files.c init2.c || die

	find .. -name .cvsignore -exec rm -f \{\} + || die
	find ../lib/edit -type f -exec chmod a-x \{\} + || die
}

src_compile() {
	tc-export CC

	local GENTOO_INCLUDES="" GENTOO_DEFINES="-DUSE_GCU " GENTOO_LIBS="$($(tc-getPKG_CONFIG) ncurses --libs)"

	if use sdl || use X || use gtk || use Xaw3d; then
		GENTOO_DEFINES="${GENTOO_DEFINES} -DUSE_EGO_GRAPHICS -DUSE_TRANSPARENCY \
			-DSUPPORT_GAMMA"
	fi

	if use sdl || use X || use Xaw3d; then
		GENTOO_DEFINES="${GENTOO_DEFINES} -DUSE_PRECISE_CMOVIE -DUSE_UNIXSOCK "
	fi

	if use sdl; then
		GENTOO_INCLUDES="${GENTOO_INCLUDES} $(sdl-config --cflags)"
		GENTOO_DEFINES="${GENTOO_DEFINES} -DUSE_SDL "
		GENTOO_LIBS="${GENTOO_LIBS} $(sdl-config --libs) -lSDL_image -lSDL_ttf"
	fi

	if use X; then
		GENTOO_INCLUDES="${GENTOO_INCLUDES} -I/usr/X11R6/include "
		GENTOO_DEFINES="${GENTOO_DEFINES} -DUSE_X11 "
		GENTOO_LIBS="${GENTOO_LIBS} -L/usr/X11R6/lib -lX11 "
	fi

	if use Xaw3d; then
		GENTOO_INCLUDES="${GENTOO_INCLUDES} -I/usr/X11R6/include "
		GENTOO_DEFINES="${GENTOO_DEFINES} -DUSE_XAW "
		GENTOO_LIBS="${GENTOO_LIBS} -L/usr/X11R6/lib -lXaw -lXmu -lXt -lX11 "
	fi

	if use gtk; then
		GENTOO_INCLUDES="${GENTOO_INCLUDES} $($(tc-getPKG_CONFIG) gtk+-2.0 --cflags)"
		GENTOO_DEFINES="${GENTOO_DEFINES} -DUSE_GTK2 "
		GENTOO_LIBS="${GENTOO_LIBS} $($(tc-getPKG_CONFIG) gtk+-2.0 --libs) "
		GTK_SRC_FILE="main-gtk2.c"
		GTK_OBJ_FILE="main-gtk2.o"
	else
		GTK_SRC_FILE=""
		GTK_OBJ_FILE=""
	fi

	if use amd64; then
		GENTOO_DEFINES="${GENTOO_DEFINES} -DLUA_NUM_TYPE=int "
	fi

	GENTOO_INCLUDES="${GENTOO_INCLUDES} -Ilua -I."
	GENTOO_DEFINES="${GENTOO_DEFINES} -DUSE_LUA"

	emake -j1 \
		INCLUDES="${GENTOO_INCLUDES}" \
		DEFINES="${GENTOO_DEFINES}" \
		depend

	emake tolua

	emake \
		COPTS="${CFLAGS}" \
		INCLUDES="${GENTOO_INCLUDES}" \
		DEFINES="${GENTOO_DEFINES}" \
		LIBS="${GENTOO_LIBS} -lm" \
		BINDIR="${EPREFIX}/usr/bin" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)/${PN}" \
		GTK_SRC_FILE="${GTK_SRC_FILE}" \
		GTK_OBJ_FILE="${GTK_OBJ_FILE}"
}

src_install() {
	emake -j1 \
		DESTDIR="${D}" \
		OWNER="nobody" \
		BINDIR="${EPREFIX}/usr/bin" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)/${PN}" install

	cd .. || die
	dodoc *.txt

	dodir /var/games
	touch "${ED}/var/games/${PN}-scores.raw" || die

	fperms 660 /var/games/${PN}-scores.raw
	fowners root:gamestat /var/games/${PN}-scores.raw
	fperms g+s /usr/bin/${PN}
}

pkg_postinst() {
	ewarn "ToME ${PV} is not save-game compatible with 2.3.0 and previous versions."
	echo
	ewarn "If you have older save files and you wish to continue those games,"
	ewarn "you'll need to remerge the version of ToME with which you started"
	ewarn "those save-games."
}
