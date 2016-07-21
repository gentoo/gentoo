# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Cross conversion environment of NMR spectra"
HOMEPAGE="http://fermi.pharm.hokudai.ac.jp/olivia/api/index.php/Xyza2pipe_src"
SRC_URI="http://fermi.pharm.hokudai.ac.jp/olivia/documents/xyza2pipe.tgz -> ${P}.tgz"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="olivia"
IUSE=""

S="${WORKDIR}"/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-gentoo.patch
	tc-export CC
	mkdir bin
}

src_install() {
	local i
	dodoc README FEEDBACK
	cd bin || die
	for i in *; do
		newbin ${i}{,-olivia}
	done
}
