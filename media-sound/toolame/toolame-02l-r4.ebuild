# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils flag-o-matic toolchain-funcs

DESCRIPTION="tooLAME - an optimized mpeg 1/2 layer 2 audio encoder"
HOMEPAGE="http://www.planckenergy.com"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86"
IUSE=""

PATCHES=(
	"${FILESDIR}/${P}-gentoo.diff"
	"${FILESDIR}/${P}-uint.patch"
	"${FILESDIR}/${P}-uint32_t.patch"
)

src_prepare() {
	# fix #571774 by restoring pre-GCC5 inline semantics
	append-cflags -std=gnu89

	append-lfs-flags
	tc-export CC

	default
}

src_install() {
	dobin ${PN}
	dodoc README HISTORY FUTURE html/* text/*
}
