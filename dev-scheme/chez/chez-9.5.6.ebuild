# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CSV="csv${PV}"

inherit toolchain-funcs

DESCRIPTION="A programming language based on R6RS"
HOMEPAGE="https://cisco.github.io/ChezScheme/ https://github.com/cisco/ChezScheme"
SRC_URI="https://github.com/cisco/ChezScheme/releases/download/v${PV}/${CSV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${CSV}"

# Chez Scheme itself is Apache 2.0, but it vendors LZ4 (BSD-2),
# Nanopass (MIT), stex (MIT), and zlib (ZLIB).
LICENSE="Apache-2.0 BSD-2 MIT ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="X examples ncurses threads"

RDEPEND="
	X? ( x11-libs/libX11 )
	ncurses? ( sys-libs/ncurses )
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/tinfo.patch" )

src_prepare() {
	tc-export AR CC CXX LD RANLIB

	default
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
		--temproot="${D}"  # required in order for DESTDIR to be respected
		--installschemename=chezscheme
		--installpetitename=chezscheme-petite
		--installscriptname=chezscheme-script
		--nogzip-man-pages
	)
	sh ./configure "${myconfargs[@]}" || die
}

src_install() {
	default

	if ! use examples; then
		rm -r "${D}/usr/$(get_libdir)/${CSV}/examples" || die
	fi
}
