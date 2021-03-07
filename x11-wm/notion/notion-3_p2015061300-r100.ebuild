# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..2} )

inherit lua-single toolchain-funcs readme.gentoo-r1

DESCRIPTION="Notion is a tiling, tabbed window manager for the X window system"
HOMEPAGE="https://notionwm.net/"
SRC_URI="https://github.com/raboof/${PN}/archive/${PV/_p/-}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls xinerama +xrandr"

RDEPEND="${LUA_DEPS}
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	nls? ( sys-devel/gettext )
	xinerama? ( x11-libs/libXinerama )
	xrandr? ( x11-libs/libXrandr )"
DEPEND="${RDEPEND}"
# luac is called at build time
BDEPEND="${LUA_DEPS}
	virtual/pkgconfig"

# mod_xrandr references mod_xinerama
REQUIRED_USE="${LUA_REQUIRED_USE}
	xrandr? ( xinerama )"

# needs slingshot,... not in tree
RESTRICT=test

PATCHES=(
	"${FILESDIR}"/${PN}-3_p2015061300-pkg-config.patch
)

S=${WORKDIR}/${P/_p/-}

src_prepare() {
	default

	sed -e "/^CFLAGS/{s: =: +=: ; s:-Os:: ; s:-g::}" \
		-e "/^LDFLAGS/{s: =: +=: ; s:-Wl,--as-needed::}" \
		-i system-autodetect.mk || die
	echo > build/lua-detect.mk
}

src_configure() {
	{	echo "CFLAGS += -D_DEFAULT_SOURCE"
		echo "PREFIX=${EROOT}/usr"
		echo "DOCDIR=\$(PREFIX)/share/doc/${PF}"
		echo "ETCDIR=${EROOT}/etc/${PN}"
		echo "LIBDIR=\$(PREFIX)/$(get_libdir)"
		echo "VARDIR=${EROOT}/var/cache/${PN}"
		echo "X11_PREFIX=${EROOT}/usr"
		echo "STRIPPROG=true"
		echo "CC=$(tc-getCC)"
		echo "AR=$(tc-getAR)"
		echo "RANLIB=$(tc-getRANLIB)"
		echo "LUA_MANUAL=1"
		echo "LUA=${LUA}"
		echo "LUAC=/usr/bin/luac5.1"
		echo "LUA_LIBS=$(lua_get_LIBS)"
		echo "LUA_INCLUDES=$(lua_get_CFLAGS)"
		use nls || echo "DEFINES+=-DCF_NO_LOCALE -DCF_NO_GETTEXT"
	} > system-local.mk

	if ! use xinerama ; then
		sed -e 's/mod_xinerama//g' -i modulelist.mk || die
	fi

	if ! use xrandr ; then
		sed -e 's/mod_xrandr//g' -i modulelist.mk || die
		sed -e '/mod_xrandr/d' \
			-i etc/cfg_defaults.lua || die
	fi
}

src_install() {
	default

	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}"/notion

	insinto /usr/share/xsessions
	doins "${FILESDIR}"/notion.desktop

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}

DOC_CONTENTS="If you want notion to have an ability to view a file based on its
guessed MIME type you should emerge app-misc/run-mailcap."
