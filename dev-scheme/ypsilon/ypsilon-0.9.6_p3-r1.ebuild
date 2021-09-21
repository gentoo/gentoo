# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

MY_P="${P/_p/.update}"
DESCRIPTION="R6RS-compliant Scheme implementation for real-time applications"
HOMEPAGE="https://code.google.com/p/ypsilon/"
SRC_URI="https://ypsilon.googlecode.com/files/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples threads"

DEPEND="app-arch/cpio"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-asneeded.patch
	"${FILESDIR}"/${P}-clang-cflags.patch
)

src_compile() {
	use threads && append-flags "-pthread"

	# Fix build failure with GCC 11
	# bug #787866
	append-cppflags -DNO_TLS

	emake \
		PREFIX="${EPREFIX}/usr" \
		AS="$(tc-getAS)" \
		CXX="$(tc-getCXX)" \
		CPPFLAGS="${CPPFLAGS}" \
		CXXFLAGS="${CXXFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${D}" install

	if use examples; then
		docinto examples
		dodoc example/*
	fi
}
