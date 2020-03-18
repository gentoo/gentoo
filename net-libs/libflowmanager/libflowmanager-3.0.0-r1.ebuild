# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils ltprune

DESCRIPTION="A library that measures and reports on packet flows"
HOMEPAGE="https://research.wand.net.nz/software/libflowmanager.php"
SRC_URI="https://research.wand.net.nz/software/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/3"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

DEPEND="
	>=net-libs/libtrace-3.0.6
"
RDEPEND="
	${DEPEND}
"
PATCHES=(
	"${FILESDIR}"/${PN}-3.0.0-stdint_h.patch
)

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default

	prune_libtool_files
}
