# Copyright 2022-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LUA_COMPAT=( lua5-1 luajit )

inherit lua-single toolchain-funcs flag-o-matic

DESCRIPTION="Ncurses based, vim-like spreadsheet calculator"
HOMEPAGE="https://github.com/andmarti1424/sc-im"
SRC_URI="https://github.com/andmarti1424/sc-im/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}/src"

LICENSE="BSD-4"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~x86"
IUSE="lua ods plots tmux wayland X xls xlsx"
REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"

DEPEND="
	sys-libs/ncurses:=
	lua? (
		${LUA_DEPS}
	)
	ods? (
		dev-libs/libxml2
		dev-libs/libzip
	)
	plots? ( sci-visualization/gnuplot )
	tmux? ( app-misc/tmux )
	wayland? ( gui-apps/wl-clipboard )
	X? ( x11-misc/xclip )
	xls? (
		dev-libs/libxls
	)
	xlsx? (
		dev-libs/libxlsxwriter
		dev-libs/libxml2
		dev-libs/libzip
	)
"
RDEPEND="${DEPEND}"
BDEPEND="app-alternatives/yacc
	virtual/pkgconfig"

pkg_setup() {
	CONFLICTING=$(usex tmux "tmux " "")$(usex wayland "wayland " "")$(usex X "X" "")
	if ( use tmux && ( use wayland || use X ) ) ; then
		elog "Conflicting flags for clipboard support are set: ${CONFLICTING}"
		elog "tmux support has been preferred."
	elif ( use wayland && use X ) ; then
		elog "Conflicting flags for clipboard support are set: ${CONFLICTING}"
		elog "Wayland support has been preferred."
	fi

	# Run lua setup
	lua-single_pkg_setup
}

src_prepare() {
	default

	# Clean Makefile from all sorts of flag / lib setting
	sed -i -e '/CFLAGS +=\|LDLIBS +=/d' Makefile \
		|| die "sed fix failed. Uh-oh..."
	# Also clean the now useless comments and logic
	sed -i -e '/#\|if\|else/d' Makefile \
		|| die "sed fix failed. Uh-oh..."
}

src_configure() {
	tc-export CC PKG_CONFIG

	LDLIBS="-lm"

	# default flags that dont need optional dependencies
	append-cflags -Wall -g \
		-DNCURSES \
		-D_XOPEN_SOURCE_EXTENDED -D_GNU_SOURCE \
		'-DSNAME=\"sc-im\"' \
		'-DHELP_PATH=\"/usr/share/sc-im\"' \
		'-DLIBDIR=\"/usr/share/doc/sc-im\"' \
		'-DDFLT_PAGER=\"less\"' \
		'-DDFLT_EDITOR=\"vim\"' \
		-DUSECOLORS \
		'-DHISTORY_FILE=\"sc-iminfo\"' \
		'-DHISTORY_DIR=\".cache\"' \
		'-DCONFIG_FILE=\"scimrc\"' \
		'-DCONFIG_DIR=\".config/sc-im\"' \
		'-DINS_HISTORY_FILE=\"sc-iminfo\"' \
		-DUNDO \
		-DMAXROWS=1048576 \
		-DUSELOCALE \
		-DMOUSE \
		'-DDEFAULT_OPEN_FILE_UNDER_CURSOR_CMD=\""scopen"\"' \
		-DAUTOBACKUP \
		-DHAVE_PTHREAD

	# setting default clipboard commands
	if use tmux ; then
		append-cflags '-DDEFAULT_COPY_TO_CLIPBOARD_CMD=\""tmux load-buffer"\"'
		append-cflags '-DDEFAULT_PASTE_FROM_CLIPBOARD_CMD=\""tmux show-buffer"\"'
	elif use wayland ; then
		append-cflags '-DDEFAULT_COPY_TO_CLIPBOARD_CMD=\""wl-copy <"\"'
		append-cflags '-DDEFAULT_PASTE_FROM_CLIPBOARD_CMD=\""wl-paste"\"'
	elif use X ; then
		append-cflags '-DDEFAULT_COPY_TO_CLIPBOARD_CMD=\""xclip -i -selection clipboard <"\"'
		append-cflags '-DDEFAULT_PASTE_FROM_CLIPBOARD_CMD=\""xclip -o -selection clipboard"\"'
	fi

	# optional feature dependency
	use plots && append-cflags -DGNUPLOT
	if use xls; then
		append-cflags -DXLS $(${PKG_CONFIG} --cflags libxls)
		LDLIBS+=" $(${PKG_CONFIG} --libs libxls)"
	fi
	if use xlsx || use ods ; then
		append-cflags -DODS -DXLSX $(${PKG_CONFIG} --cflags libxml-2.0 libzip)
		LDLIBS+=" -DODS -DXLSX $(${PKG_CONFIG} --libs libxml-2.0 libzip)"
	fi
	if use xlsx ; then
		append-cflags -DXLSX_EXPORT $(${PKG_CONFIG} --cflags xlsxwriter)
		LDLIBS+=" -DXLSX_EXPORT $(${PKG_CONFIG} --libs xlsxwriter)"
	fi
	if use lua ; then
		append-cflags -DXLUA $(${PKG_CONFIG} --cflags lua)
		LDLIBS+=" -DXLUA $(${PKG_CONFIG} --libs lua) -rdynamic"
	fi
	append-cflags $(${PKG_CONFIG} --cflags ncursesw) || append-cflags $(${PKG_CONFIG} --cflags ncurses)
	LDLIBS+=" $(${PKG_CONFIG} --libs ncursesw)" || LDLIBS+=" $(${PKG_CONFIG} --libs ncurses)"
}

src_compile() {
	emake LDLIBS="${LDLIBS}" CFLAGS="${CFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" prefix="/usr" install
	einstalldocs
}
