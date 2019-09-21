# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="Culmus fonts support for latex"
HOMEPAGE="http://ivritex.sourceforge.net/"
SRC_URI="mirror://sourceforge/ivritex/${P}_src.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ~hppa ia64 ppc ppc64 sparc x86"
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

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins examples/*
		insinto /usr/share/doc/${PF}/examples/hiriq
		doins examples/hiriq/*
	fi
}
