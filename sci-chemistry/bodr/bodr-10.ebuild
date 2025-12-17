# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The Blue Obelisk Data Repository listing element and isotope properties"
HOMEPAGE="https://sourceforge.net/projects/bodr"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="dev-libs/libxslt"

src_prepare() {
	default
	sed -i -e "s/COPYING//g" Makefile.* || die
}
