# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="John Stracke's Essays 1743 font"
HOMEPAGE="https://www.thibault.org/fonts/essays/"
SRC_URI="otf? ( https://www.thibault.org/fonts/essays/${P}-1-otf.tar.gz )
	ttf? ( https://www.thibault.org/fonts/essays/${P}-1-ttf.tar.gz )"
S="${WORKDIR}/${PN}"

LICENSE="|| ( LGPL-2.1 OFL-1.1 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~s390 ~sparc ~x86 ~x64-macos"
IUSE="+otf ttf"

REQUIRED_USE="|| ( otf ttf )"

src_install() {
	local FONT_SUFFIX="$(usex otf otf '') $(usex ttf ttf '')"
	font_src_install
}
