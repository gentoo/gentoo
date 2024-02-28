# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo toolchain-funcs

DESCRIPTION="A programming language based on R6RS"
HOMEPAGE="https://cisco.github.io/ChezScheme/
	https://github.com/cisco/ChezScheme/"
SRC_URI="https://github.com/cisco/ChezScheme/releases/download/v${PV}/csv${PV//a}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}/csv${PV//a}"

# Chez Scheme itself is Apache 2.0, but it vendors Nanopass and stex
# which are both MIT licensed.
LICENSE="Apache-2.0 MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm ~x86"
IUSE="X ncurses threads"

RDEPEND="
	app-arch/lz4:=
	sys-apps/util-linux
	sys-libs/zlib:=
	X? ( x11-libs/libX11 )
	ncurses? ( sys-libs/ncurses:= )
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	virtual/pkgconfig
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
	# See official docs for translation guide.
	# https://cisco.github.io/ChezScheme/release_notes/v9.6/release_notes.html
	# "t" for threading + arch_map + "le" for Linux (hardcoded for now)
	local -A arch_map=(
		[amd64]=a6
		[arm]=arm32
		[ppc]=ppc32
		[x86]=i3
	)
	local machine="$(usex threads 't' '')${arch_map[${ARCH}]}le"

	local -a myconfargs=(
		--machine="${machine}"
		--libkernel
		--nogzip-man-pages

		--installprefix="/usr"
		--installbin="/usr/bin"
		--installlib="/usr/$(get_libdir)"
		--installman="/usr/share/man"
		--installschemename=chezscheme
		--installpetitename=chezscheme-petite
		--installscriptname=chezscheme-script

		$(usex threads '--threads' '')
		$(usex ncurses '' '--disable-curses')
		$(usex X '' '--disable-x11')

		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		LD="$(tc-getLD)"

		LZ4="$($(tc-getPKG_CONFIG) --libs liblz4)"
		ZLIB="$($(tc-getPKG_CONFIG) --libs zlib)"
	)
	edob sh ./configure "${myconfargs[@]}"
}

src_install() {
	# TempRoot == DESTDIR
	emake TempRoot="${ED}" install
	einstalldocs

	find "${ED}/usr/$(get_libdir)/csv${PV//a}/examples" \
		 \( -name "*.md" -o -name "*.so" \)  -delete || die
}
