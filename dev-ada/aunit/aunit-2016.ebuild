# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multiprocessing

MYP=${PN}-gpl-${PV}-src

DESCRIPTION="Ada unit testing framework"
HOMEPAGE="http://libre.adacore.com/tools/aunit/"
SRC_URI="http://mirrors.cdn.adacore.com/art/573990c6c7a447658d00e1cb -> ${MYP}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-lang/gnat-gpl"
DEPEND="${RDEPEND}
	dev-ada/gprbuild"

S="${WORKDIR}"/${MYP}

PATCHES=( "${FILESDIR}"/${P}-gentoo.patch )

src_compile() {
	emake GPRBUILD="gprbuild -j$(makeopts_jobs)"
}

src_install() {
	emake INSTALL="${D}"usr install
	einstalldocs
	mv "${D}"usr/share/doc/${PN}/* "${D}"usr/share/doc/${PF}/ || die
	rmdir "${D}"usr/share/doc/${PN} || die
	mv "${D}"usr/share/examples/${PN} "${D}"usr/share/doc/${PF}/examples || die
	rmdir "${D}"usr/share/examples || die
	dodoc features-* known-problems-*
}
