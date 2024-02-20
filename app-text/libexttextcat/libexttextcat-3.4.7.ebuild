# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Library implementing N-gram-based text categorization"
HOMEPAGE="https://wiki.documentfoundation.org/Libexttextcat"
SRC_URI="https://dev-www.libreoffice.org/src/${P}.tar.xz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~amd64-linux ~x86-linux"

src_configure() {
	econf \
		--disable-werror
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
