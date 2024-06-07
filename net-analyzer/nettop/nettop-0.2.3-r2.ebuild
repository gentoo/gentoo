# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools toolchain-funcs

DESCRIPTION="top-like program for network activity"
HOMEPAGE="https://web.archive.org/web/20060615083852/http://srparish.net/software/"
SRC_URI="https://web.archive.org/web/20060705095248if_/http://srparish.net:80/software/nettop-0.2.3.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc x86"

RDEPEND="
	sys-libs/slang
	net-libs/libpcap"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc411.patch
	"${FILESDIR}"/${P}-offbyone.patch
)

src_prepare() {
	default

	eautoreconf #871408
	sed -i 's/configure.in/configure.ac/' Makefile.in || die

	tc-export CC
}

src_install() {
	dosbin nettop
	einstalldocs
}
