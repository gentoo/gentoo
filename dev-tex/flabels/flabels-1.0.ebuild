# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="Macros for typesetting lables for the back of files or binders"
HOMEPAGE="http://www.ctan.org/tex-archive/help/Catalogue/entries/flabels.html"
# downloaded from:
# ftp.ctan.org/tex-archive/help/Catalogue/entries/flabels.tar.gz
SRC_URI="mirror://gentoo/${P}.tar.gz"
LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/${PN}
DOCS="README"
