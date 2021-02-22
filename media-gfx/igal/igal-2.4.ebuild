# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=${PN}2-${PV}

DESCRIPTION="Static HTML image gallery generator"
HOMEPAGE="https://igal.trexler.at"
SRC_URI="https://github.com/solbu/igal2/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

RDEPEND="
	dev-lang/perl
	virtual/imagemagick-tools
	virtual/jpeg"
DEPEND=""

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	sed -i "s!/usr/local!${EPREFIX}/usr!" igal2 igal2.1 igal2.pl \
		utilities/igal2-cron.sh utilities/igal2-cron1.sh utilities/igal2.sh

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
