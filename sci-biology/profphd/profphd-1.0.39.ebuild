# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="Secondary structure and solvent accessibility predictor"
HOMEPAGE="https://rostlab.org/owiki/index.php/PROFphd_-_Secondary_Structure,_Solvent_Accessibility_and_Transmembrane_Helices_Prediction"
SRC_URI="ftp://rostlab.org/profphd/${P}.tar.xz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="dev-lang/perl"
RDEPEND="${DEPEND}
	dev-perl/librg-utils-perl
	sci-libs/profnet
	sci-libs/profphd-utils
"

src_prepare() {
	sed \
		-e '/ln -s/s:prof$:profphd:g' \
		-i src/prof/Makefile || die
	epatch "${FILESDIR}"/${P}-perl.patch
}

src_compile() {
	emake prefix="${EPREFIX}/usr"
}

src_install() {
	emake prefix="${EPREFIX}/usr" DESTDIR="${D}" install
}
