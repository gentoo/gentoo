# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A collection of useful, independent include files for C/Assembler developers"
HOMEPAGE="https://openwince.sourceforge.net/include/"
SRC_URI="https://downloads.sourceforge.net/openwince/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"

src_prepare() {
	default

	eautoreconf
}
