# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Filebench - A Model Based File System Workload Generator"
HOMEPAGE="https://sourceforge.net/projects/filebench/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"
IUSE="auto-completion"

RDEPEND="
	auto-completion? ( dev-libs/libtecla )
"
DEPEND="${RDEPEND}
	sys-devel/flex
	sys-devel/bison
"

PATCHES=( "${FILESDIR}"/${PN}-fix-automagic-libtecla-dependency.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_with auto-completion libtecla)
}
