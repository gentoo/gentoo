# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Switch in backup servers on a LAN"
SRC_URI="http://www.vergenet.net/linux/${PN}/download/${PV}/${P}.tar.gz"
HOMEPAGE="http://www.vergenet.net/linux/fake/"

SLOT="0"
KEYWORDS="~amd64 x86"
LICENSE="GPL-2+"
IUSE=""

PATCHES=(
	"${FILESDIR}/fix-ldflags.patch"
)

src_prepare() {
	default
	emake patch
}

src_install(){
	emake \
		ROOT_DIR="${ED}" \
		MAN8_DIR="${ED}/usr/share/man/man8" \
		DOC_DIR="${ED}/usr/share/doc/${PF}" \
		install
	dodoc AUTHORS ChangeLog README docs/*
}
