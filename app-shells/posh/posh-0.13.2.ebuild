# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Reimplementation of Bourne shell based on pdksh"
HOMEPAGE="https://salsa.debian.org/clint/posh"
SRC_URI="mirror://debian/pool/main/p/posh/${P/-/_}.tar.xz"

LICENSE="GPL-2+ BSD public-domain"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="app-arch/xz-utils"

src_configure() {
	local myconf=(
		--exec-prefix="${EPREFIX:-/}"
	)
	econf "${myconf[@]}"
}
