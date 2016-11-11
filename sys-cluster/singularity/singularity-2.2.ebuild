# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils

DESCRIPTION="Application containers for Linux"
HOMEPAGE="http://singularity.lbl.gov/"
SRC_URI="https://github.com/${PN}ware/${PN}/releases/download/${PV}/${P}.tar.gz"

SLOT="0"
LICENSE="BSD"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

src_configure() {
	econf --with-userns
}

src_install() {
	MAKEOPTS+=" -j1"
	default
	prune_libtool_files
	dodoc ChangeLog
	use examples && dodoc -r examples
}
