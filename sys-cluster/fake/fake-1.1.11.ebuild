# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Switch in backup servers on a LAN"
HOMEPAGE="https://projects.horms.net/projects/fake/"
SRC_URI="https://projects.horms.net/projects/${PN}/download/${PV}/${P}.tar.gz"
LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=(
	"${FILESDIR}/fix-ldflags.patch"
)

src_prepare() {
	default
	emake patch
}

src_install() {
	emake \
		ROOT_DIR="${ED}" \
		MAN8_DIR="${ED}/usr/share/man/man8" \
		DOC_DIR="${ED}/usr/share/doc/${PF}" \
		install
	dodoc AUTHORS ChangeLog README docs/*
}
