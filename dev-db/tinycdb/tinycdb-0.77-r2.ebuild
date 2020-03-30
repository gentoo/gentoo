# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

DESCRIPTION="A very fast and simple package for creating and reading constant data bases"
HOMEPAGE="http://www.corpit.ru/mjt/tinycdb.html"
SRC_URI="http://www.corpit.ru/mjt/${PN}/${P/-/_}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm64 hppa ~ia64 ~mips ppc x86"
IUSE="static-libs"
RESTRICT="test"

RDEPEND="!dev-db/cdb"

PATCHES=(
	"${FILESDIR}"/${PN}-gentoo.patch
	"${FILESDIR}"/${PN}-umask.patch
	"${FILESDIR}"/${PN}-uclibc.patch
)

src_prepare() {
	default

	sed -i "/^libdir/s:/lib:/$(get_libdir):" Makefile
}

src_compile() {
	local targets="shared"
	use static-libs && targets+=" staticlib piclib"

	emake \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} ${LDFLAGS}" \
		${targets}
}

src_install() {
	local targets="install install-sharedlib"
	use static-libs && targets+=" install-piclib"

	emake \
		prefix="${EPREFIX}"/usr \
		mandir="${EPREFIX}"/usr/share/man \
		DESTDIR="${D}" \
		${targets}
	einstalldocs
}
