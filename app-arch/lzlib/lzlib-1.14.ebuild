# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/antoniodiazdiaz.asc
inherit toolchain-funcs verify-sig

DESCRIPTION="Library for lzip compression"
HOMEPAGE="https://www.nongnu.org/lzip/lzlib.html"
SRC_URI="https://download.savannah.gnu.org/releases/lzip/${PN}/${P}.tar.gz"
SRC_URI+=" verify-sig? ( https://download.savannah.gnu.org/releases/lzip/${PN}/${P/_/-}.tar.gz.sig )"

LICENSE="libstdc++" # fancy form of GPL-2+ with library exception
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-antoniodiazdiaz )"

src_configure() {
	local myconf=(
		--enable-shared
		--disable-static
		--disable-ldconfig
		--prefix="${EPREFIX}"/usr
		--libdir='$(prefix)'/$(get_libdir)
		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		CFLAGS="${CFLAGS}"
		CPPFLAGS="${CPPFLAGS}"
		LDFLAGS="${LDFLAGS}"
	)

	# not autotools-based
	./configure "${myconf[@]}" || die
}

src_install() {
	emake DESTDIR="${D}" install install-man
	einstalldocs
}
