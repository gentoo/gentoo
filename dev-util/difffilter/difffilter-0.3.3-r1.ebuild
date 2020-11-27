# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Filter files out of unified diffs using POSIX extended regular expressions"
HOMEPAGE="http://ohnopub.net/~ohnobinki/difffilter/"
SRC_URI="http://mirror.ohnopub.net/mirror/${PN}/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux"

RDEPEND=">=dev-libs/liblist-2.3.1
	dev-libs/libstrl
	dev-libs/tre"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-fno-common.patch )

src_install() {
	default
	newman "${FILESDIR}"/${PN}-0.3.3.man1 ${PN}.1
}
