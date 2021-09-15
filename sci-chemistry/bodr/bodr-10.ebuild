# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The Blue Obelisk Data Repository listing element and isotope properties"
HOMEPAGE="https://sourceforge.net/projects/bodr"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc-macos"

BDEPEND="dev-libs/libxslt"

src_prepare() {
	default
	sed -i -e "s/COPYING//g" Makefile.* || die
}
