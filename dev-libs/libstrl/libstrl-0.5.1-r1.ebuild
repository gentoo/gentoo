# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs multilib-minimal

DESCRIPTION="Compat library for functions like strlcpy(), strlcat(), strnlen(), getline()"
HOMEPAGE="http://ohnopub.net/~ohnobinki/libstrl/"
SRC_URI="http://mirror.ohnopub.net/mirror/${P}.tar.bz2"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x64-macos"
IUSE="doc static-libs test"
RESTRICT="!test? ( test )"

DEPEND="
	doc? ( app-doc/doxygen )
	test? ( dev-libs/check )
"

src_prepare() {
	default
	multilib_copy_sources
}

multilib_src_configure() {
	tc-export AR
	econf \
		$(use_enable static-libs static) \
		$(use_with doc doxygen) \
		$(use_with test check)
}
