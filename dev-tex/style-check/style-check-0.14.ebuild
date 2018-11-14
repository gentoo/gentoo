# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=4

DESCRIPTION="Parses LaTeX-formatted text in search of forbidden phrases"
HOMEPAGE="http://www.cs.umd.edu/~nspring/software/style-check-readme.html https://github.com/nspring/style-check"
SRC_URI="http://www.cs.umd.edu/~nspring/software/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="test"

RDEPEND="dev-lang/ruby"
DEPEND="test? ( dev-lang/ruby )"

src_install() {
	dodir /etc/style-check.d
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${ED}" install
	dohtml README.html
}
