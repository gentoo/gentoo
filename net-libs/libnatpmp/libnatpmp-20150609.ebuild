# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="An alternative protocol to UPnP IGD specification"
HOMEPAGE="http://miniupnp.free.fr/libnatpmp.html"
SRC_URI="http://miniupnp.free.fr/files/download.php?file=${P}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ~hppa ~mips ~ppc ~ppc64 sparc x86"

PATCHES=(
	"${FILESDIR}"/respect-FLAGS-20140401.patch
	"${FILESDIR}"/respect-libdir-20120821.patch
	"${FILESDIR}"/remove-static-lib-20130911.patch
)

src_configure() {
	tc-export CC
}

src_install() {
	# Override HEADERS for missing declspec.h wrt #506832
	emake HEADERS='declspec.h natpmp.h' PREFIX="${ED}" GENTOO_LIBDIR="$(get_libdir)" install

	dodoc Changelog.txt README
	doman natpmpc.1
}
