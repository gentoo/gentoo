# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit font

DESCRIPTION="SIL Opentype Unicode fonts for Ethiopic languages"
HOMEPAGE="http://scripts.sil.org/AbyssinicaSIL"
SRC_URI="mirror://gentoo/ttf-${P}.tgz"

LICENSE="OFL"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~x86-fbsd ~ppc-macos ~x86-macos"
IUSE="doc"

DOCS="OFL-FAQ.txt"
FONT_SUFFIX="ttf"

FONT_S="${WORKDIR}/ttf-${P}"
S="${FONT_S}"

src_install() {
	font_src_install
	use doc && dodoc *.pdf
}
