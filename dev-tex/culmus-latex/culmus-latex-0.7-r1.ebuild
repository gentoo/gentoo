# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="Culmus fonts support for latex"
HOMEPAGE="https://ivritex.sourceforge.net/"
SRC_URI="mirror://sourceforge/ivritex/${P}_src.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm64 ~hppa ~ia64 ppc ppc64 ~riscv sparc x86"
IUSE="examples"

RDEPEND="virtual/latex-base"
DEPEND="${RDEPEND}
	|| (
		>=media-fonts/culmus-0.110[fancy]
		<media-fonts/culmus-0.110
	)
	app-text/t1utils"

src_compile() {
	emake CULMUSDIR=/usr/share/fonts/culmus/
	echo "Map culmus.map" > ${PN}.cfg || die
}

src_install() {
	emake CULMUSDIR=/usr/share/fonts/culmus/ \
		DESTDIR="${D}" \
		TEXMFROOT=/usr/share/texmf-site \
		pkginstall

	insinto /etc/texmf/updmap.d
	doins ${PN}.cfg

	dodoc README

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
