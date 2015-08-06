# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/notion/notion-9999.ebuild,v 1.10 2015/08/06 08:44:55 xmw Exp $

EAPI=5

inherit eutils git-r3 multilib toolchain-funcs flag-o-matic

DESCRIPTION="Notion is a tiling, tabbed window manager for the X window system"
HOMEPAGE="http://notion.sourceforge.net"
EGIT_REPO_URI="https://github.com/raboof/${PN}.git"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
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

# needs luaposix,slingshot,... not in tree
RESTRICT=test

src_prepare() {
	append-cflags -D_DEFAULT_SOURCE

	sed -e "/^CFLAGS=/s:=:+=:" \
		-e "/^CFLAGS/{s:-Os:: ; s:-g::}" \
		-e "/^LDFLAGS=/{s:=:+=: ; s:-Wl,--as-needed::}" \
		-e "/^CC=/s:=:?=:" \
		-e "s:^\(PREFIX=\).*$:\1${ROOT}usr:" \
		-e "s:^\(ETCDIR=\).*$:\1${ROOT}etc/notion:" \
		-e "s:^\(LIBDIR=\).*:\1\$(PREFIX)/$(get_libdir):" \
		-e "s:^\(DOCDIR=\).*:\1\$(PREFIX)/share/doc/${PF}:" \
		-e "s:^\(LUA_DIR=\).*$:\1\$(PREFIX)/usr:" \
		-e "s:^\(VARDIR=\).*$:\1${ROOT}var/cache/${PN}:" \
		-e "s:^\(X11_PREFIX=\).*:\1\$(PREFIX)/usr:" \
		-i system-autodetect.mk || die
	sed -e 's/gcc/$(CC)/g' \
		-i ioncore/Makefile || die
	export STRIPPROG=true

	tc-export CC
}

src_configure() {
	use nls || export DEFINES=" -DCF_NO_LOCALE -DCF_NO_GETTEXT"

	if ! use xinerama ; then
		sed -e 's/mod_xinerama//g' -i modulelist.mk || die
	fi

	if ! use xrandr ; then
		sed -e 's/mod_xrandr//g' -i modulelist.mk || die
	fi
}

src_compile() {
	emake CC="$(tc-getCC)" AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)"
}

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr install

	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}"/notion

	insinto /usr/share/xsessions
	doins "${FILESDIR}"/notion.desktop
}

pkg_postinst() {
	elog "If you want notion to have an ability to view a file based on its"
	elog "guessed MIME type you should emerge app-misc/run-mailcap."
}
