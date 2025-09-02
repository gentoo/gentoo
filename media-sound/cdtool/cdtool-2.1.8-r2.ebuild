# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="collection of command-line utilities to control cdrom devices"
HOMEPAGE="http://hinterhof.net/cdtool/"
SRC_URI="http://hinterhof.net/cdtool/dist/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~sparc x86"

RDEPEND="!media-sound/cdplay"

PATCHES=(
	"${FILESDIR}/${P}-glibc-2.10.patch"
	"${FILESDIR}/${P}-fix-build-system.patch"
)

src_prepare() {
	default

	# bug 899848
	eautoreconf
}
