# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit latex-package

DESCRIPTION="Offers syntax/railroad diagrams"
HOMEPAGE="http://www.ctan.org/tex-archive/support/rail/"
SRC_URI="http://mirror.ctan.org/support/${PN}.zip
	-> ${P}.zip"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="app-text/texlive"
DEPEND="${RDEPEND}
	app-arch/unzip
	sys-devel/bison
	sys-devel/flex"

S=${WORKDIR}/${PN}

src_compile() {
	emake -j 1 || die "make failed"
}

src_install() {
	latex-package_src_doinstall sty doc

	dobin rail || die "Installing the rail tool failed"

	newman rail.man rail.1 || die "Installing the manpage failed"
}
