# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit autotools-multilib

DESCRIPTION="Open implementation of the Advanced Access Content System (AACS) specification"
HOMEPAGE="https://www.videolan.org/developers/libaacs.html"
SRC_URI="https://downloads.videolan.org/pub/videolan/libaacs/${PV}/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 sparc x86"
IUSE="static-libs"

RDEPEND=">=dev-libs/libgcrypt-1.5.3:0=[${MULTILIB_USEDEP}]
	>=dev-libs/libgpg-error-1.12[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	sys-devel/flex
	virtual/yacc"

DOCS=( ChangeLog KEYDB.cfg README.txt )

AUTOTOOLS_IN_SOURCE_BUILD=1

src_configure() {
	local myeconfargs=(
		--disable-optimizations
	)
	autotools-multilib_src_configure
}
