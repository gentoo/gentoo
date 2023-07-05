# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit latex-package

DESCRIPTION="Hebrew support for TeX"
HOMEPAGE="https://ivritex.sourceforge.net/"
SRC_URI="mirror://sourceforge/ivritex/${P}.tar.gz"

LICENSE="LPPL-1.2"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ppc64 sparc x86"
RESTRICT="mirror"

src_install() {
	export VARTEXFONTS="${T}/fonts"

	emake TEX_ROOT="${D}"/usr/share/texmf install
}
