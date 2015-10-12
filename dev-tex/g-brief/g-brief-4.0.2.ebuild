# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit latex-package

S=${WORKDIR}/${PN}

# checksum from official ftp site changes frequently so we mirror it
DESCRIPTION="LaTeX styles for formless letters in German or English"
SRC_URI="mirror://gentoo/${P}.zip"
HOMEPAGE="http://www.ctan.org/tex-archive/macros/latex/contrib/g-brief/"
LICENSE="LPPL-1.2"

IUSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~ia64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"

RDEPEND="!>=app-text/tetex-2.96"
DEPEND="${RDEPEND}
	app-arch/unzip"

TEXMF="/usr/share/texmf-site"
