# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Compat library for functions like strlcpy(), strlcat(), strnlen(), getline()"
HOMEPAGE="http://ohnopub.net/~ohnobinki/libstrl/"
SRC_URI="http://mirror.ohnopub.net/mirror/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x64-macos"
IUSE="doc test"
RESTRICT="!test? ( test )"

BDEPEND="
	doc? ( app-doc/doxygen )
	test? ( dev-libs/check )
"

src_configure() {
	tc-export AR

	econf \
		$(use_with doc doxygen) \
		$(use_with test check)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
