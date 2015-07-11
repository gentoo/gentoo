# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/itex2mml/itex2mml-1.5.2.ebuild,v 1.2 2015/07/11 20:37:33 zlogene Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="A LaTeX into XHTML/MathML converter"
HOMEPAGE="http://golem.ph.utexas.edu/~distler/blog/itex2MML.html"
SRC_URI="http://golem.ph.utexas.edu/~distler/blog/files/itexToMML-${PV}.tar.gz"
LICENSE="|| ( GPL-2+ MPL-1.1 LGPL-2+ )"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}/itexToMML/itex-src"

src_compile() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" CFLAGS="${CFLAGS}"
}

src_install() {
	dobin itex2MML
	dodoc ../README
}
