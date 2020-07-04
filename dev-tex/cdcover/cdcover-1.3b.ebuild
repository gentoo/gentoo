# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

S=${WORKDIR}/cdcover

DESCRIPTION="LaTeX package used to create CD case covers"
HOMEPAGE="https://www.ctan.org/tex-archive/macros/latex/contrib/cd-cover/"
SRC_URI="mirror://gentoo/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~sparc x86"
IUSE=""

# checksum from official ftp site changes frequently so we mirror it
