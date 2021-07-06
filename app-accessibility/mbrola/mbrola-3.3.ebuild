# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Speech synthesizer based on the concatenation of diphones"
HOMEPAGE="https://github.com/numediart/MBROLA"
SRC_URI="https://github.com/numediart/MBROLA/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="AGPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="app-accessibility/mbrola-voices"

S="${WORKDIR}/MBROLA-${PV}"

src_compile() {
	emake -j1 EXT_CFLAGS="${CFLAGS}"
}

src_install() {
	dobin Bin/mbrola
	DOCS=( README.md Documentation/*.txt )
	einstalldocs
}
