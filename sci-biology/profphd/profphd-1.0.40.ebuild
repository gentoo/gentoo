# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Secondary structure and solvent accessibility predictor"
HOMEPAGE="https://rostlab.org/owiki/index.php/PROFphd_-_Secondary_Structure,_Solvent_Accessibility_and_Transmembrane_Helices_Prediction"
SRC_URI="ftp://rostlab.org/profphd/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="dev-lang/perl"
RDEPEND="
	${DEPEND}
	dev-perl/librg-utils-perl
	sci-libs/profnet
	sci-libs/profphd-utils"

PATCHES=(
	"${FILESDIR}"/${PN}-1.0.39-perl.patch
	"${FILESDIR}"/${PN}-1.0.40-symlink.patch
)

src_compile() {
	emake prefix="${EPREFIX}"/usr
}

src_install() {
	emake prefix="${EPREFIX}"/usr DESTDIR="${D}" install
	einstalldocs
}
