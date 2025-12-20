# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit libtool

DESCRIPTION="Library implementing N-gram-based text categorization"
HOMEPAGE="https://wiki.documentfoundation.org/Libexttextcat"
SRC_URI="https://dev-www.libreoffice.org/src/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

PATCHES=(
	"${FILESDIR}"/${PN}-3.4.7-lto.patch
)

src_prepare() {
	default

	# Needed for LTO flags to be passed down to the linker
	elibtoolize
}

src_configure() {
	econf \
		--disable-werror
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
