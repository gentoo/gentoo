# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit toolchain-funcs

MY_PN='spacenav'
DESCRIPTION="libspnav is a replacement for the magellan library with a cleaner API"
HOMEPAGE="http://spacenav.sourceforge.net/"
SRC_URI="https://github.com/FreeSpacenav/libspnav/releases/download/v${PV}/libspnav-${PV}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
IUSE="static-libs X"

CDEPEND="X? ( x11-libs/libX11 )"
RDEPEND="app-misc/spacenavd[X?]
	${CDEPEND}"
DEPEND="${CDEPEND}"

src_configure() {
	local args=(
		--disable-opt
		--disable-debug
		$(use_enable X x11)
	)
	econf "${args[@]}"
}

src_compile() {
	local args=(
		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		incpaths=-I.
		libpaths=
	)
	emake "${args[@]}"
}

src_install() {
	local args=(
		DESTDIR="${D}"
		libdir="$(get_libdir)"
	)
	emake "${args[@]}" install

	# The custom configure script does not support --disable-static
	# and conditionally patching $(lib_a) out of Makefile.in does not
	# seem like a very maintainable option, hence we delete the .a file
	# after "make install", instead.
	use static-libs || find "${D}" -type f -name \*.a -delete
}
