# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A utility to merge apache logs in chronological order"
HOMEPAGE="http://mergelog.sourceforge.net"
SRC_URI="mirror://sourceforge/mergelog/${P}.tar.gz"

IUSE=""
SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ppc x86"

RDEPEND="sys-libs/zlib"
DEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-splitlog.patch
	"${FILESDIR}"/${P}-asneeded.patch
)

src_prepare() {
	eapply_user
	eautoreconf
}
