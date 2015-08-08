# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib toolchain-funcs readme.gentoo

DESCRIPTION="Notion is a tiling, tabbed window manager for the X window system"
HOMEPAGE="http://notion.sourceforge.net"
SRC_URI="https://github.com/raboof/${PN}/archive/${PV/_p/-}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nls xinerama +xrandr"

RDEPEND=">=dev-lang/lua-5.1:0=
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	nls? ( sys-devel/gettext )
	xinerama? ( x11-libs/libXinerama )
	xrandr? ( x11-libs/libXrandr )"
DEPEND="${RDEPEND}
		virtual/pkgconfig"

# mod_xrandr references mod_xinerama
REQUIRED_USE="xrandr? ( xinerama )"

# needs luaposix,slingshot,... not in tree
RESTRICT=test

S=${WORKDIR}/${P/_p/-}

src_prepare() {
	epatch "${FILESDIR}/${P}-pkg-config.patch"

	sed -e "/^CFLAGS/{s: =: +=: ; s:-Os:: ; s:-g::}" \
		-e "/^LDFLAGS/{s: =: +=: ; s:-Wl,--as-needed::}" \
		-i system-autodetect.mk || die
	echo > build/lua-detect.mk
}

src_configure() {
	{	echo "CFLAGS += -D_DEFAULT_SOURCE"
		echo "PREFIX=${ROOT}usr"
		echo "DOCDIR=\$(PREFIX)/share/doc/${PF}"
		echo "ETCDIR=${ROOT}etc/${PN}"
		echo "LIBDIR=\$(PREFIX)/$(get_libdir)"
		echo "VARDIR=${ROOT}var/cache/${PN}"
		echo "X11_PREFIX=${ROOT}usr"
		echo "STRIPPROG=true"
		echo "CC=$(tc-getCC)"
		echo "AR=$(tc-getAR)"
		echo "RANLIB=$(tc-getRANLIB)"
		echo "LUA_MANUAL=1"
		echo "LUA=\$(BINDIR)/lua"
		echo "LUAC=\$(BINDIR)/luac"
		echo "LUA_LIBS=\$(shell pkg-config --libs lua)"
		echo "LUA_INCLUDES=\$(shell pkg-config --cflags)"
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

	readme.gentoo_src_install
}

DOC_CONTENTS="If you want notion to have an ability to view a file based on its
guessed MIME type you should emerge app-misc/run-mailcap."
