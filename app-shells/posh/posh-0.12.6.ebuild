# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Reimplementation of Bourne shell based on pdksh"
HOMEPAGE="https://packages.debian.org/posh"
SRC_URI="mirror://debian/pool/main/p/posh/${P/-/_}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="app-arch/xz-utils"

S=${WORKDIR}/posh

src_configure() {
	local myconf=(
		--exec-prefix="${EPREFIX:-/}"
	)
	econf "${myconf[@]}"
}
