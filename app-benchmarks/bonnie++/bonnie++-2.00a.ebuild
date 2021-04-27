# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Hard drive bottleneck testing benchmark suite"
HOMEPAGE="https://www.coker.com.au/bonnie++/"
SRC_URI="https://www.coker.com.au/${PN}/${P}.tgz"
S="${WORKDIR}/${P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="debug"

PATCHES=(
	"${FILESDIR}/${PN}-1.97-zcav-array-indexing-fix.patch" #309319
	"${FILESDIR}/${PN}-2.00a-gcc11.patch" #768402
	"${FILESDIR}/${PN}-2.00a-makefile.patch" #426788
)

DOCS=( "credits.txt" "README.txt" "README-2.00" "debian/changelog" )
HTML_DOCS=( "readme.html" )

src_prepare() {
	default

	# Fix path in manpage #431684
	sed -e "/readme.html/s/bonnie++/${PF}\/html/" -i bonnie++.8 || die
}

src_configure() {
	local myeconfargs=(
		--disable-stripping
		$(usex debug "--enable-debug" "")
	)

	econf "${myeconfargs[@]}"
}
