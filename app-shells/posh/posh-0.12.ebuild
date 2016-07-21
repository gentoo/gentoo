# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools-utils

DESCRIPTION="Reimplementation of Bourne shell based on pdksh"
HOMEPAGE="http://packages.debian.org/posh"
SRC_URI="mirror://debian/pool/main/p/posh/${P/-/_}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RESTRICT="test"

src_configure() {
	myeconfargs=(
		--exec-prefix=/
	)
	autotools-utils_src_configure
}
