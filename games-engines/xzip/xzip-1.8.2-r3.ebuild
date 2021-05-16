# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="X interface to Z-code based text games"
HOMEPAGE="http://www.eblong.com/zarf/xzip.html"
SRC_URI="http://www.eblong.com/zarf/ftp/xzip182.tar.Z"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test"

DEPEND="x11-libs/libX11"
RDEPEND=${DEPEND}

S="${WORKDIR}/xzip"

src_compile() {
	emake \
		CFLAGS="${CFLAGS} -DAUTO_END_MODE" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin xzip
	dodoc README
	doman xzip.1
}
