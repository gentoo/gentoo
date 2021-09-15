# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Pseudorandom number sequence test"
HOMEPAGE="http://www.fourmilab.ch/random/"
SRC_URI="mirror://gentoo/random-${PV}.zip"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

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
