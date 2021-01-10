# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="A commandline-based, portable human IP stack for UNIX/Linux"
HOMEPAGE="http://nemesis.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P/_}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~sparc ~x86"

RDEPEND="
	net-libs/libpcap
"
DEPEND="
	${RDEPEND}
	=net-libs/libnet-1.0*
"

DOCS="CREDITS ChangeLog README"

PATCHES=(
	"${FILESDIR}"/${PN}-1.4-fileio.patch
	"${FILESDIR}"/${PN}-1.4-libnet-1.0.patch
	"${FILESDIR}"/${PN}-1.4-prototcp.patch
	"${FILESDIR}"/${PN}-1.4-fno-common.patch
)

src_prepare() {
	default
	eautoreconf
}
