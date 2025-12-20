# Copyright 2003-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Utility for getting info out of DVDs"
HOMEPAGE="https://sourceforge.net/projects/lsdvd/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ppc ppc64 ~riscv ~sparc x86"

RDEPEND="media-libs/libdvdread:0="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.17-autotools.patch
)

DOCS=(AUTHORS README ChangeLog)

src_prepare() {
	default
	eautoreconf
}
