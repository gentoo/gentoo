# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A utility to merge apache logs in chronological order"
HOMEPAGE="http://mergelog.sourceforge.net"
SRC_URI="mirror://sourceforge/mergelog/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc x86"

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-splitlog.patch
	"${FILESDIR}"/${P}-asneeded.patch
)

src_prepare() {
	eapply_user
	eautoreconf
}
