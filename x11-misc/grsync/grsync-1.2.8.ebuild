# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A gtk frontend to rsync"
HOMEPAGE="http://www.opbyte.it/grsync/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""
SRC_URI="http://www.opbyte.it/release/${P}.tar.gz"

DEPEND=">=x11-libs/gtk+-2.16:2"
RDEPEND="${DEPEND}
	net-misc/rsync"
BDEPEND="virtual/pkgconfig
	dev-util/intltool"

DOCS="AUTHORS NEWS README"

PATCHES=( "${FILESDIR}"/${PN}-1.2.6-gcc-10.patch )

src_configure() {
	econf --disable-unity
}
