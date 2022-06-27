# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs flag-o-matic

MY_PV="VERSION_${PV//./_}"
DESCRIPTION="Markdown translator producing HTML5, roff documents in the ms and man formats"
HOMEPAGE="https://kristaps.bsd.lv/lowdown/"
SRC_URI="https://github.com/kristapsdz/lowdown/archive/refs/tags/${MY_PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND="virtual/libcrypt:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/lowdown-0.10.0-pkgconfig-libmd.patch"
	"${FILESDIR}/lowdown-0.11.1-linking.patch"
)

src_configure() {
	append-flags -fPIC
	tc-export CC AR

	./configure \
		PREFIX="/usr" \
		MANDIR="/usr/share/man" \
		LDFLAGS="${LDFLAGS}" \
		CPPFLAGS="${CPPFLAGS}" \
		LIBDIR="/usr/$(get_libdir)" \
		|| die "./configure failed"
}

src_compile() {
	emake $(usex elibc_musl UTF8_LOCALE=C.UTF-8 '')
}

src_test() {
	emake regress
}
