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
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-2.7.0-respect-tc-env.patch
)

src_prepare() {
	default

	# Edit pkgconfig
	sed "s#VERSION#${PV}#" "${FILESDIR}/${PN}.pc" > "${S}/${PN}.pc" || die
	sed -i "s#LIBDIR#$(get_libdir)#" "${S}/${PN}.pc" || die

	mv Makefile.sharedlibrary Makefile || die "failed to rename makefile"
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dodir /usr/$(get_libdir)
	dodir /usr/include
	emake INSTALL_PREFIX="${ED}"/usr LIBDIR="/$(get_libdir)" install

	insinto /usr/$(get_libdir)/pkgconfig/
	doins ${S}/${PN}.pc
}
