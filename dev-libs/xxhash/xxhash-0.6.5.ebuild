# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit flag-o-matic toolchain-funcs

DESCRIPTION="Extremely fast non-cryptographic hash algorithm"
HOMEPAGE="http://www.xxhash.com"
SRC_URI="https://github.com/Cyan4973/xxHash/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2 GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ia64 ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x64-macos"
IUSE="static-libs"

DEPEND=""

S="${WORKDIR}/xxHash-${PV}"
PATCHES=(
	"${FILESDIR}"/${PN}-0.6.5-do-not-compile-xxhash.o-twice.patch
)

src_configure() {
	use hppa && replace-flags '-O*' '-O0'
}

src_compile() {
	PREFIX="${EPREFIX}/usr" \
	LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
	emake AR="$(tc-getAR)" CC="$(tc-getCC)"
}

src_install() {
	PREFIX="${EPREFIX}/usr" \
	LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
	MANDIR="${EPREFIX}/usr/share/man/man1" \
	emake DESTDIR="${D}" install

	if ! use static-libs ; then
		rm "${ED}"/usr/$(get_libdir)/libxxhash.a || die
	fi
}
