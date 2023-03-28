# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Embeddable Javascript engine"
HOMEPAGE="https://duktape.org"
SRC_URI="https://duktape.org/${P}.tar.xz"

IUSE="cli"
LICENSE="MIT"
# Upstream don't maintain binary compatibility
# https://github.com/svaarala/duktape/issues/1524
SLOT="0/${PV}"
KEYWORDS="~amd64"

DEPENDS="cli? ( sys-libs/linenoise )"
RDEPENDS="${DEPENDS}"

PATCHES=(
	"${FILESDIR}"/${PN}-2.7.0-respect-tc-env.patch
	"${FILESDIR}"/${P}-underlinked-libm.patch
	"${FILESDIR}"/${P}-fix-cmdline.patch
)

src_prepare() {
	default
	mv Makefile.sharedlibrary Makefile || die "failed to rename makefile"
}

src_compile() {
	emake CC="$(tc-getCC)" INSTALL_PREFIX="${EPREFIX}"/usr LIBDIR="/$(get_libdir)"
	if use cli; then
		emake CC="$(tc-getCC)" INSTALL_PREFIX="${EPREFIX}"/usr LIBDIR="/$(get_libdir)" \
			  -f Makefile.cmdline
	fi
}

src_install() {
	dodir /usr/$(get_libdir)
	dodir /usr/include
	emake DESTDIR="${D}" INSTALL_PREFIX="${EPREFIX}"/usr LIBDIR="/$(get_libdir)" install
	if use cli; then
		dobin "${S}"/duk
	fi
}
