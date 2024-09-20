# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Static HTML image gallery generator"
HOMEPAGE="https://igal.trexler.at/"
SRC_URI="https://github.com/solbu/${PN}2/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}2-${PV}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

RDEPEND="
	dev-lang/perl
	virtual/imagemagick-tools
	media-libs/libjpeg-turbo"

src_prepare() {
	default
	sed -i -e "s|/usr/local/lib/igal2|${EPREFIX}/usr/share/igal2|g" \
		igal2 igal2.1 || die
	sed -i -e "s|/usr/local/bin/igal2|exec ${EPREFIX}/usr/bin/igal2|" \
		-e "1s|^#.*|#!${EPREFIX}/bin/bash|" \
		utilities/igal2.sh || die

	# set IGALDIR
	sed -i -e "s|/usr/local/share/igal2|${EPREFIX}/usr/share/igal2|g" \
		igal2 igal2.1 || die
}

src_compile() { :; }

src_install() {
	dobin igal2 utilities/igal2.sh
	dosym igal2 /usr/bin/igal
	doman igal2.1
	dodoc ChangeLog README
	insinto /usr/share/igal2
	doins *.html tile.png igal2.css
}
