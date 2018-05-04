# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Shared library to impliment the scrypt algorithm"
HOMEPAGE="https://github.com/technion/libscrypt"
SRC_URI="https://github.com/technion/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 arm ~mips ppc ppc64 sparc x86"
IUSE="static-libs"

DEPEND=""
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
)

pkg_setup() {
	export LIBDIR=${PREFIX}/$(get_libdir)
	# -D_FORTIFY_SOURCE=2 in Makefile
	export CFLAGS_EXTRA="${CFLAGS} -U_FORTIFY_SOURCE"
	export LDFLAGS_EXTRA="${LDFLAGS}"
	export PREFIX=/usr
	unset CFLAGS
	unset LDFLAGS
}

src_compile() {
	emake \
		CC=$(tc-getCC)
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="${PREFIX}/$(get_libdir)" install
	use static-libs && emake DESTDIR="${D}" LIBDIR="${PREFIX}/$(get_libdir)" install-static

	einstalldocs
}
