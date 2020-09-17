# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A stand-alone client/server 9P library including ixpc client"
HOMEPAGE="https://libs.suckless.org/deprecated/libixp"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86"

PATCHES=(
	# https://code.google.com/p/libixp/issues/detail?id=2
	# https://code.google.com/p/wmii/issues/detail?id=247
	# https://bugs.gentoo.org/393299
	"${FILESDIR}"/${P}-gentoo.patch
)

src_configure() {
	myixpconf=(
		PREFIX="${EPREFIX}"/usr
		LIBDIR="${EPREFIX}"/usr/$(get_libdir)
		LIBS=
		CC="$(tc-getCC) -c"
		LD="$(tc-getCC) ${LDFLAGS}"
		AR="$(tc-getAR) crs"
		MAKESO=1
		SOLDFLAGS="-shared"
	)
}

src_compile() {
	emake "${myixpconf[@]}"
}

src_install() {
	emake "${myixpconf[@]}" DESTDIR="${D}" install
	dolib.so lib/libixp{,_pthread}.so
	einstalldocs
}
