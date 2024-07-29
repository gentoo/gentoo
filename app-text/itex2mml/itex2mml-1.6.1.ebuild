# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="LaTeX to XHTML/MathML converter"
HOMEPAGE="https://golem.ph.utexas.edu/~distler/blog/itex2MML.html"
SRC_URI="https://golem.ph.utexas.edu/~distler/blog/files/itexToMML-${PV}.tar.gz"
S="${WORKDIR}/itexToMML/itex-src"

LICENSE="|| ( GPL-2+ MPL-1.1 LGPL-2+ )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"

src_configure() {
	# fix bug #719070
	sed -i -e "s/\$(CXX) \$(CFLAGS)/ \$(CXX) ${CFLAGS} ${LDFLAGS}/" Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)"
}

src_install() {
	dobin itex2MML
	dodoc ../README
}
