# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="Recodes HTML file using a new character set"
HOMEPAGE="http://bisqwit.iki.fi/source/htmlrecode.html"
SRC_URI="http://bisqwit.iki.fi/src/arch/${P}.tar.bz2"

KEYWORDS="~amd64 ~ppc ~x86"
LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND=">=sys-apps/sed-4"
RDEPEND=""

PATCHES=(
	"${FILESDIR}/${PN}-1.3.1-ar.patch"
)

src_prepare() {
	default
	touch .depend argh/.depend
}

src_configure() {
	:
}

src_compile() {
	local makeopts=(
		AR="$(tc-getAR)"
		CPPDEBUG=
		CXX="$(tc-getCXX)"
		CXXFLAGS="${CXXFLAGS}"
		LDFLAGS="${LDFLAGS}"
	)
	emake "${makeopts[@]}" -C argh libargh.a
	emake "${makeopts[@]}" htmlrecode
}

src_install() {
	dobin htmlrecode
	HTML_DOCS="README.html" einstalldocs
}
