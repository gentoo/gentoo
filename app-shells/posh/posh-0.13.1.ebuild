# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Reimplementation of Bourne shell based on pdksh"
HOMEPAGE="https://salsa.debian.org/clint/posh"
SRC_URI="mirror://debian/pool/main/p/posh/${P/-/_}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="app-arch/xz-utils"

S=${WORKDIR}/posh

src_prepare() {
	default
	# the tarball apparently contains outdated files
	eautoreconf
}

src_configure() {
	local myconf=(
		--exec-prefix="${EPREFIX:-/}"
	)
	econf "${myconf[@]}"
}
