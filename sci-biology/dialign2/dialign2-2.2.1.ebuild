# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-biology/dialign2/dialign2-2.2.1.ebuild,v 1.1 2015/03/29 14:22:43 jlec Exp $

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Multiple sequence alignment"
HOMEPAGE="http://bibiserv.techfak.uni-bielefeld.de/dialign"
SRC_URI="http://bibiserv.techfak.uni-bielefeld.de/applications/dialign/resources/downloads/dialign-2.2.1-src.tar.gz"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

S="${WORKDIR}"/dialign_package

src_compile() {
	emake -C src \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS} -I. -DCONS -c"
}

src_install() {
	dobin src/${PN}-2
	insinto /usr/share/${PN}
	doins dialign2_dir/*

	cat >> "${T}"/80${PN} <<- EOF
	DIALIGN2_DIR="${EPREFIX}/usr/share/${PN}"
	EOF
	doenvd "${T}"/80${PN}
}
