# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs

DESCRIPTION="Computes changes between binary or text files and creates deltas"
HOMEPAGE="https://xdelta.googlecode.com/"
SRC_URI="https://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND=">=dev-libs/glib-2
	>=sys-libs/zlib-1.1.4:="
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	eapply_user
	eapply "${FILESDIR}"/${P}-m4.patch
	eapply "${FILESDIR}"/${P}-glib2.patch
	eapply "${FILESDIR}"/${P}-pkgconfig.patch

	eautoreconf
}

src_configure() {
	tc-export CC
	default
}
