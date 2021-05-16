# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="A GameSpy server browser"
HOMEPAGE="http://aluigi.altervista.org/papers.htm#gslist"
SRC_URI="mirror://gentoo/${P}.zip"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"
IUSE="web"

RDEPEND="dev-libs/geoip"
DEPEND="${RDEPEND}"
BDEPEND="app-arch/unzip"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
)

src_prepare() {
	default
	rm -f gslist gslistsql *.exe *.dll || die
}

src_compile() {
	tc-export CC

	emake \
		SQL=0 \
		$(use web || echo GSWEB=0)
}

src_install() {
	dobin ${PN}
	dodoc ${PN}.txt
}
