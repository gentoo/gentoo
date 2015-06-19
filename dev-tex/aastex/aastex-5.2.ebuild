# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/aastex/aastex-5.2.ebuild,v 1.12 2013/04/14 17:56:00 ulm Exp $

inherit latex-package

MY_P=${PN/latex-/}${PV//./}
S=${WORKDIR}/${MY_P}
DESCRIPTION="LaTeX package used to mark up manuscripts for American Astronomical Society journals. (AASTeX)"
HOMEPAGE="http://www.journals.uchicago.edu/AAS/AASTeX/"
SRC_URI="http://www.journals.uchicago.edu/AAS/AASTeX/${MY_P}.tar.gz"

LICENSE="LPPL-1.3"
SLOT="0"
KEYWORDS="alpha amd64 hppa ~mips ppc sparc x86"
IUSE=""
