# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Modal editor inspired by vim"
HOMEPAGE="http://kakoune.org/ https://github.com/mawww/kakoune"
SRC_URI="https://github.com/mawww/kakoune/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="static-libs"

DEPEND="sys-libs/ncurses:0=[unicode]"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}"/kakoune-2020.01.16-enable-ebuild-syntax-highlight.patch )

src_configure() { :; }

src_compile() {
	cd src/ || die

	emake static=$(usex static-libs yes no) all
}

src_test() {
	cd src/ || die
	emake test
}

src_install() {
	emake PREFIX="${D}"/usr docdir="${D}/usr/share/doc/${PF}" install

	rm "${D}/usr/share/man/man1/kak.1.gz" || die
	doman doc/kak.1
}
