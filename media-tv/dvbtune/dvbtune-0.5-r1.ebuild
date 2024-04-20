# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="simple tuning app for DVB cards"
HOMEPAGE="https://sourceforge.net/projects/dvbtools"
SRC_URI="mirror://sourceforge/dvbtools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="xml"

RDEPEND="xml? ( dev-libs/libxml2 )"
DEPEND="${RDEPEND}
	sys-kernel/linux-headers"

PATCHES=(
	"${FILESDIR}"/${PF}-gentoo.diff
	"${FILESDIR}"/${PN}-0.5-stdint.patch
)

src_prepare() {
	default

	tc-export CC
}

src_compile() {
	emake dvbtune

	use xml && emake xml2vdr
}

src_install() {
	dobin dvbtune

	use xml && dobin xml2vdr

	dodoc README scripts/*
}
