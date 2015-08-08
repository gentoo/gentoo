# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit latex-package

IUSE=""

DESCRIPTION="Hebrew support for TeX"
HOMEPAGE="http://ivritex.sourceforge.net/"
SRC_URI="mirror://sourceforge/ivritex/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="LPPL-1.2"

SLOT="0"
DEPEND=""
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"

src_install () {
	export VARTEXFONTS="${T}/fonts"

	make TEX_ROOT="${D}"/usr/share/texmf install || die

}
