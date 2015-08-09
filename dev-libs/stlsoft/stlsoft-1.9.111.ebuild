# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Robust, Lightweight, Cross-platform, Template Software"
HOMEPAGE="http://www.stlsoft.org/"
SRC_URI="mirror://sourceforge/stlsoft/${P}-hdrs.zip"

LICENSE="BSD"
SLOT="1.9"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

src_install() {
	default
	insinto /usr
	doins -r include/
}
