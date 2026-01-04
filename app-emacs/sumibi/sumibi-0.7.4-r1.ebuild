# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Statistical Japanese input method using the Internet as a large corpus"
HOMEPAGE="http://sumibi.org/sumibi/sumibi.html"

SRC_URI="mirror://sourceforge.jp/sumibi/26504/${P}.tar.gz"
S="${WORKDIR}/${P}/client/elisp"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DOCS=( ../../CHANGELOG ../../CREDITS ../../README )
SITEFILE="50${PN}-gentoo-${PV}.el"
