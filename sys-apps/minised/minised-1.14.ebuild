# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="a smaller, cheaper, faster SED implementation"
HOMEPAGE="http://www.exactcode.de/oss/minised/"
SRC_URI="http://dl.exactcode.de/oss/minised/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

src_prepare() {
	tc-export CC
}
