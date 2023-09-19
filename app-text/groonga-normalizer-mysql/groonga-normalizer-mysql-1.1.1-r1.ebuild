# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Groonga plugin that provides MySQL compatible normalizers"
HOMEPAGE="https://groonga.org/"
SRC_URI="https://packages.groonga.org/source/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-text/groonga"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

DOCS=( README.md )

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# ruby is only used for tests
	econf --without-ruby
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
	rm -r "${ED}"/usr/share/doc/${PN} || die
}
