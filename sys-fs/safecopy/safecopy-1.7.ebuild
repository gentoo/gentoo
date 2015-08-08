# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit base

DESCRIPTION="Data recovery tool to fault-tolerantly extract data from damaged (io-errors) devices or files"
HOMEPAGE="http://safecopy.sourceforge.net"
SRC_URI="mirror://sourceforge/safecopy/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND=""
DEPEND=""

DOCS=( README )

src_prepare() {
	base_src_prepare
	sed -e 's:bin/sh:bin/bash:' \
		-i "${S}"/test/test.sh || die
}

src_configure() {
	econf
	if use test; then
		cd "${S}"/simulator
		econf
	fi
}

src_compile() {
	emake
	if use test; then
		cd "${S}"/simulator
		emake
	fi
}

src_test() {
	cd "${S}"/test
	./test.sh || die
}
