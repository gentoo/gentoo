# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-chemistry/xyza2pipe/xyza2pipe-20101129.ebuild,v 1.1 2010/11/29 21:09:09 jlec Exp $

EAPI="3"

inherit eutils toolchain-funcs

DESCRIPTION="Cross conversion environment of NMR spectra"
HOMEPAGE="http://fermi.pharm.hokudai.ac.jp/olivia/api/index.php/Xyza2pipe_src"
SRC_URI="mirror://gentoo/${P}.tgz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="olivia"
IUSE=""

S="${WORKDIR}"/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-gentoo.patch
	tc-export CC
}

src_install() {
	emake DESTDIR="${ED}" install || die
	dodoc README FEEDBACK || die
}
