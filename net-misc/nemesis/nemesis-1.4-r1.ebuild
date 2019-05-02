# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="A commandline-based, portable human IP stack for UNIX/Linux"
HOMEPAGE="http://nemesis.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P/_}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 sparc x86"

RDEPEND="
	net-libs/libpcap
"
DEPEND="
	${RDEPEND}
	=net-libs/libnet-1.0*
"

DOCS="CREDITS ChangeLog README"

PATCHES=(
	"${FILESDIR}"/${P}-fileio.patch
	"${FILESDIR}"/${P}-libnet-1.0.patch
	"${FILESDIR}"/${P}-prototcp.patch
)

src_prepare() {
	default
	eautoreconf
}
