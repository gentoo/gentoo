# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Pseudorandom number sequence test"
HOMEPAGE="http://www.fourmilab.ch/random/"
SRC_URI="mirror://gentoo/random-${PV}.zip"

SLOT="0"
LICENSE="public-domain"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=""
DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-gentoo.patch
	tc-export CC
}

src_install() {
	dobin ${PN}
	dohtml ${PN}.html ${PN}itle.gif
}
