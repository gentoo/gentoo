# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="A programming language based on R6RS"
HOMEPAGE="https://cisco.github.io/ChezScheme/ https://github.com/cisco/ChezScheme"
SRC_URI="https://github.com/cisco/ChezScheme/releases/download/v${PV}/csv${PV//a}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/csv${PV//a}

# Chez Scheme itself is Apache 2.0, but it vendors Nanopass and stex
# which are both MIT licensed.
LICENSE="Apache-2.0 MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
IUSE="X ncurses threads"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	app-arch/lz4:=
	sys-apps/util-linux
	sys-libs/zlib:=
	ncurses? ( sys-libs/ncurses:= )
"
DEPEND="${RDEPEND}"
RDEPEND="
	${RDEPEND}
	X? ( x11-libs/libX11 )
"

src_prepare() {
	tc-export AR CC CXX LD RANLIB

	default

	if use ncurses ; then
		local nclibs="\"$($(tc-getPKG_CONFIG) --libs ncurses)\""
		sed -i "s|ncursesLib=-lncurses|ncursesLib=${nclibs}|g" configure || die
	fi

	# Remove -Werror
	sed -i "/^C = /s|-Werror||g" c/Mf-* || die
}

src_configure() {
	local myconfargs=(
		$(usex threads '--threads' '')
		$(usex ncurses '' '--disable-curses')
		$(usex X '' '--disable-x11')
		--installprefix="/usr"
		--installbin="/usr/bin"
		--installlib="/usr/$(get_libdir)"
		--installman="/usr/share/man"
		--installschemename=chezscheme
		--installpetitename=chezscheme-petite
		--installscriptname=chezscheme-script
		--libkernel
		--nogzip-man-pages
		LZ4=$($(tc-getPKG_CONFIG) --libs liblz4)
		ZLIB=$($(tc-getPKG_CONFIG) --libs zlib)
	)
	sh ./configure "${myconfargs[@]}" || die
}

src_install() {
	# TempRoot == DESTDIR
	emake TempRoot="${D}" install
	einstalldocs

	find "${ED}"/usr/$(get_libdir)/csv${PV//a}/examples \
		 \( -name "*.md" -o -name "*.so" \)  -delete || die
}
