# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Random number sequence test and entropy calculation"
HOMEPAGE="https://www.fourmilab.ch/random/ https://github.com/Fourmilab/ent_random_sequence_tester"
SRC_URI="https://dev.gentoo.org/~jstein/dist/${P}.zip"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~x86"

BDEPEND="app-arch/unzip"

PATCHES=( "${FILESDIR}"/${PV}-gentoo.patch )

src_prepare() {
	default
	tc-export CC
}

src_install() {
	dobin ${PN}
	dodoc ${PN}.html ${PN}itle.gif
}
