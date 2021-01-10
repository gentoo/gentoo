# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A simple message/alert client for G15daemon"
HOMEPAGE="https://sourceforge.net/projects/g15daemon/"
SRC_URI="mirror://sourceforge/g15daemon/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND=">=app-misc/g15daemon-1.9.0
	dev-libs/libg15
	dev-libs/libg15render
	sys-libs/zlib
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-docdir.patch" )

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}
