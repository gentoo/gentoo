# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A simple client for DWUN"
HOMEPAGE="http://dwun.sourceforge.net/"
SRC_URI="mirror://sourceforge/dwun/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 x86"

RDEPEND="net-dialup/dwun"

PATCHES=(
	"${FILESDIR}"/${P}-gcc3.3.patch
	"${FILESDIR}"/${P}-rename-configure.ac.patch
)

src_prepare() {
	default

	eautoreconf
}
