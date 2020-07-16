# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P=posh-debian-${PV}
DESCRIPTION="Reimplementation of Bourne shell based on pdksh"
HOMEPAGE="https://salsa.debian.org/clint/posh"
SRC_URI="
	https://salsa.debian.org/clint/posh/-/archive/debian/${PV}/${MY_P}.tar.bz2"
S=${WORKDIR}/${MY_P}

LICENSE="GPL-2+ BSD public-domain"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="app-arch/xz-utils"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myconf=(
		--exec-prefix="${EPREFIX:-/}"
	)
	econf "${myconf[@]}"
}
