# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Differential X Protocol Compressor"
HOMEPAGE="http://www.vigor.nu/dxpc/"
SRC_URI="http://www.vigor.nu/dxpc/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND="x11-libs/libXt
	>=dev-libs/lzo-2"
DEPEND="${RDEPEND}
	x11-proto/xproto"

DOCS=( CHANGES README TODO )

src_install () {
	emake prefix="${ED%/}"/usr man1dir="${ED%/}"/usr/share/man/man1 install
	einstalldocs
}
