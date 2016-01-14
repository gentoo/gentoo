# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="An extremely memory-efficient hash_map implementation"
HOMEPAGE="https://github.com/sparsehash/sparsehash"
SRC_URI="https://github.com/${PN}/${PN}/archive/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

S=${WORKDIR}/${PN}-${P}

src_install() {
	default

	# Installs just every piece
	rm -rf "${ED}/usr/share/doc"
	dohtml doc/*
}
