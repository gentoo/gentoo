# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/passivetex/passivetex-1.25.ebuild,v 1.23 2012/05/09 14:21:05 aballier Exp $

inherit latex-package

S=${WORKDIR}/${PN}
DESCRIPTION="A namespace-aware XML parser written in Tex"
# Taken from: http://www.tei-c.org.uk/Software/passivetex/${PN}.zip
SRC_URI="mirror://gentoo/${P}.zip"
HOMEPAGE="http://www.tei-c.org.uk/Software/passivetex/"
LICENSE="MIT"

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x64-macos ~x86-solaris"
SLOT="0"
IUSE=""

RDEPEND="virtual/latex-base
	>=dev-tex/xmltex-1.9"

DEPEND="${RDEPEND}
	app-arch/unzip"

TEXMF=/usr/share/texmf-site

src_install() {

	insinto ${TEXMF}/tex/xmltex/passivetex
	doins *.sty *.xmt

	dodoc README.passivetex index.xml
	dohtml index.html
}
