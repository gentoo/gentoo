# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Portable, robust, fully-threaded I/O benchmark program"
HOMEPAGE="https://github.com/mkuoppal/tiobench"
SRC_URI="https://github.com/mkuoppal/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND="dev-lang/perl"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-gcc5.patch
	"${FILESDIR}"/${P}-fix-perl-shebang.patch
)

src_prepare() {
	default
	sed -i \
		-e "s:/usr/local/bin:${EPREFIX}/usr/sbin:" tiobench.pl \
		|| die "sed tiobench.pl failed"
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LINK="$(tc-getCC)" \
		DEFINES="-DLARGEFILES" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dosbin tiotest tiobench.pl scripts/tiosum.pl
	einstalldocs
}
