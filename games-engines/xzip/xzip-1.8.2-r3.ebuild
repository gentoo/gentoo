# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="X interface to Z-code based text games"
HOMEPAGE="https://www.eblong.com/zarf/xzip.html"
SRC_URI="https://www.eblong.com/zarf/ftp/xzip$(ver_rs 1-3 '').tar.Z"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"

DEPEND="x11-libs/libX11"
RDEPEND=${DEPEND}

S="${WORKDIR}/xzip"

src_compile() {
	tc-export CC
	emake \
		CFLAGS="${CFLAGS} -DAUTO_END_MODE" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin xzip
	dodoc README
	doman xzip.1
}
