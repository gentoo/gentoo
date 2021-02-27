# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="This library implements the client side of the Gadu-Gadu protocol"
HOMEPAGE="http://toxygen.net/libgadu/"
SRC_URI="https://github.com/wojtekka/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

# Bug 373215, last checked 2012.01.28
RESTRICT="test"

LICENSE="LGPL-2.1"
KEYWORDS="~alpha amd64 arm ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
SLOT="0"
IUSE="doc ssl threads"

COMMON_DEPEND="
	sys-libs/zlib
	ssl? ( net-libs/gnutls:= )
"
DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )
"
RDEPEND="${COMMON_DEPEND}"

DOCS=(AUTHORS ChangeLog NEWS README)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-static
		--disable-tests
		--without-openssl
		$(use_with ssl gnutls)
		$(use_with threads pthread)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	use doc && local HTML_DOCS=( docs/html/. )
	default
	find "${D}" -name '*.la' -type f -delete || die
}
