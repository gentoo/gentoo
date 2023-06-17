# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="Tecla command-line editing library"
HOMEPAGE="https://www.astro.caltech.edu/~mcs/tecla/"
SRC_URI="https://www.astro.caltech.edu/~mcs/tecla/${P}.tar.gz"
S="${WORKDIR}/libtecla"

LICENSE="icu"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ~riscv x86 ~amd64-linux ~x86-linux"

DEPEND="sys-libs/ncurses:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.6.1-install.patch
	"${FILESDIR}"/${PN}-1.6.1-no-strip.patch
	"${FILESDIR}"/${PN}-1.6.3-ldflags.patch
	"${FILESDIR}"/${PN}-1.6.3-prll-build.patch
	"${FILESDIR}"/${PN}-1.6.1-prll-install.patch
	"${FILESDIR}"/${PN}-1.6.3-static-libs.patch
	"${FILESDIR}"/${PN}-1.6.3-secure-runpath.patch
	"${FILESDIR}"/${PN}-1.6.3-configure-clang16.patch
)

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	emake \
		OPT="" \
		LDFLAGS="${LDFLAGS}" \
		LFLAGS="$(raw-ldflags)"
}
