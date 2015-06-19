# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/leaflet/leaflet-20041222.ebuild,v 1.22 2014/08/10 21:26:52 slyfox Exp $

inherit latex-package eutils

S=${WORKDIR}/leaflet

DESCRIPTION="LaTeX package used to create leaflet-type brochures"
SRC_URI="mirror://gentoo/${P}.zip"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/leaflet/"

LICENSE="LPPL-1.3"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE=""

# checksum from official ftp site changes frequently so we mirror it

TEXMF="/usr/share/texmf-site"

RDEPEND="dev-texlive/texlive-fontsrecommended"
DEPEND="${RDEPEND} app-arch/unzip"
DOCS="README"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}/${P}-logging.patch"
}
