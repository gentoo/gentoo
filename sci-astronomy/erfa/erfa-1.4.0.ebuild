# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils

DESCRIPTION="Essential Routines for Fundamental Astronomy"
HOMEPAGE="https://github.com/liberfa/erfa"
SRC_URI="https://github.com/liberfa/erfa/releases/download/v${PV}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/1"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="static-libs"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files --all
}
