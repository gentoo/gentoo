# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="convert filenames to utf8 or any other charset"
HOMEPAGE="https://www.j3e.de/linux/convmv/"
SRC_URI="https://www.j3e.de/linux/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}"
BDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-2.05-manpage_nocompress.patch" #729544
)

src_prepare() {
	default
	sed -i -e "1s|#!/usr|#!${EPREFIX}/usr|" convmv || die
}

src_install() {
	emake DESTDIR="${D}" PREFIX="${EPREFIX}"/usr install
	dodoc CREDITS Changes TODO VERSION
}

src_test() {
	unpack ./testsuite.tar

	cd "${S}"/suite || die
	./dotests.sh || die "Tests failed"
}
