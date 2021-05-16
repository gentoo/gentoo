# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Hard drive bottleneck testing benchmark suite"
HOMEPAGE="https://www.coker.com.au/bonnie++/"
SRC_URI="https://www.coker.com.au/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~mips ppc ppc64 sparc x86"
IUSE="debug"

S="${WORKDIR}/${P}"

PATCHES=(
	"${FILESDIR}/${PN}-1.96-compile-flags.patch" #426788
	"${FILESDIR}"/${PN}-1.97-zcav-array-indexing-fix.patch #309319
)

DOCS=( README.txt README-2.00 debian/changelog credits.txt )
HTML_DOCS=( readme.html )

src_configure() {
	econf \
		$(usex debug "--enable-debug" "") \
		--disable-stripping
}

src_install() {
	dobin bonnie++ zcav bon_csv2html bon_csv2txt
	sed -i -e \
		"s:/usr/share/doc/bonnie++:${EPREFIX}/usr/share/doc/${PF}/html:g" \
		bonnie++.8 || die #431684
	doman bon_csv2html.1 bon_csv2txt.1 bonnie++.8 zcav.8
	einstalldocs
}
