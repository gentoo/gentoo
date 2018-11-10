# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit toolchain-funcs

MY_P=AudioCompress-${PV}

DESCRIPTION="Very gentle 1-band dynamic range compressor"
HOMEPAGE="https://beesbuzz.biz/code/audiocompress.php"
SRC_URI="https://beesbuzz.biz/code/audiocompress/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND=""
DEPEND=""

S=${WORKDIR}/${MY_P}

src_compile() {
	emake \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${LDFLAGS}" \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" || die "emake failed"
}

src_install() {
	dobin AudioCompress || die "dobin failed"
	dodoc ChangeLog README TODO
}
