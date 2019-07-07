# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Efficient and accurate implementation of complex error functions"
HOMEPAGE="http://apps.jcns.fz-juelich.de/doku/sc/libcerf"
SRC_URI="http://apps.jcns.fz-juelich.de/src/${PN}/${P}.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 ~arm arm64 hppa ia64 ppc ppc64 s390 sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc static-libs test"

src_configure() {
	econf --enable-shared $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
	mv "${ED}"/usr/share/man/man3/{,${PN}-}cerf.3 || die #collision with sys-apps/man-pages
	use doc || rm -r "${ED}"/usr/share/doc/${P}/html || die
}
