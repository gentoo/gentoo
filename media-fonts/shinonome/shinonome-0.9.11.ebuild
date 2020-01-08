# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Japanese bitmap fonts for X"
HOMEPAGE="http://openlab.jp/efont/shinonome/"
SRC_URI="http://openlab.jp/efont/dist/shinonome/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 s390 sh sparc x86"
# Only installs fonts
RESTRICT="strip binchecks"

BDEPEND="x11-apps/bdftopcf"

DOCS="AUTHORS BUGS ChangeLog* DESIGN* INSTALL LICENSE README THANKS TODO"
FONT_S="${S}"
FONT_SUFFIX="pcf.gz"

src_configure() {
	econf --with-pcf --without-bdf
}

src_compile() {
	default

	local i
	for i in *.pcf; do
		gzip -9 "${i}" || die
	done
}
