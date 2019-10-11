# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit font

DESCRIPTION="John Stracke's Essays 1743 font"
HOMEPAGE="https://www.thibault.org/fonts/essays/"
SRC_URI="https://www.thibault.org/fonts/essays/${P}-1-ttf.tar.gz"

LICENSE="|| ( LGPL-2.1 OFL-1.1 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~s390 ~sh ~sparc ~x86 ~x64-macos"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${PN}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
