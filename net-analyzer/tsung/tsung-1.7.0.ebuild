# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

# Seems to be misconfigured
RESTRICT="test"

inherit eutils

DESCRIPTION="Erlang's multi-protocol distributed load testing tool"
HOMEPAGE="http://tsung.erlang-projects.org/"
SRC_URI="http://tsung.erlang-projects.org/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gnuplot"

DEPEND="dev-lang/erlang"
RDEPEND="
	gnuplot? (
		sci-visualization/gnuplot
		dev-perl/Template-Toolkit
	)
	${DEPEND}
"
src_configure() {
	./configure --prefix="/usr" || die "econf failed"
}

src_compile() {
	emake
}

src_install() {
	emake -j1 DESTDIR="${D}" install
}
