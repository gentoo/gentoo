# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Embeddable Javascript engine"
HOMEPAGE="https://duktape.org"
SRC_URI="https://duktape.org/${P}.tar.xz"

LICENSE="MIT"
# Upstream don't maintain binary compatibility
# https://github.com/svaarala/duktape/issues/1524
SLOT="0/${PV}"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv ~s390 sparc x86"

PATCHES=(
	"${FILESDIR}"/${PN}-2.7.0-respect-tc-env.patch
	"${FILESDIR}"/${P}-underlinked-libm.patch
)

src_prepare() {
	default

	mv Makefile.sharedlibrary Makefile || die "failed to rename makefile"
}

src_compile() {
	emake CC="$(tc-getCC)" INSTALL_PREFIX="${EPREFIX}"/usr LIBDIR="/$(get_libdir)"
}

src_install() {
	dodir /usr/$(get_libdir)
	dodir /usr/include
	emake DESTDIR="${D}" INSTALL_PREFIX="${EPREFIX}"/usr LIBDIR="/$(get_libdir)" install
}
