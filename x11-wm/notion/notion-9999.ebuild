# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-4 )

inherit flag-o-matic lua-single toolchain-funcs readme.gentoo-r1

DESCRIPTION="Notion is a tiling, tabbed window manager for the X window system"
HOMEPAGE="https://notionwm.net/"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/raboof/${PN}.git"
else
	SRC_URI="https://github.com/raboof/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="nls"
# needs slingshot,... not in tree
RESTRICT="test"
REQUIRED_USE="${LUA_REQUIRED_USE}"

RDEPEND="
	${LUA_DEPS}
	x11-libs/libSM
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXrandr
	nls? ( sys-devel/gettext )"
DEPEND="${RDEPEND}"
# luac is called at build time
BDEPEND="
	${LUA_DEPS}
	virtual/pkgconfig"

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/965850
	# https://github.com/raboof/notion/issues/390
	append-flags -fno-strict-aliasing
	filter-lto

	tc-export AR CC PKG_CONFIG
	export INSTALL_STRIP=""

	cat > system-local.mk <<- _EOF_ || die
		PREFIX=${EPREFIX}/usr
		DOCDIR=\$(PREFIX)/share/doc/${PF}
		ETCDIR=${EPREFIX}/etc/${PN}
		LIBDIR=\$(PREFIX)/$(get_libdir)
		VARDIR=${EPREFIX}/var/cache/${PN}
		LUA_MANUAL=1
		LUA=${LUA}
		LUAC=${BROOT}/usr/bin/${ELUA/lua/luac}
		LUA_LIBS=$(lua_get_LIBS)
		LUA_INCLUDES=$(lua_get_CFLAGS)
		$(usev !nls "DEFINES+=-DCF_NO_LOCALE -DCF_NO_GETTEXT")
	_EOF_
}

src_install() {
	default

	exeinto /etc/X11/Sessions
	doexe "${FILESDIR}"/notion

	insinto /usr/share/xsessions
	doins "${FILESDIR}"/notion.desktop

	local DOC_CONTENTS="
		If you want notion to have an ability to view a file based on its
		guessed MIME type you should emerge app-misc/run-mailcap."
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
