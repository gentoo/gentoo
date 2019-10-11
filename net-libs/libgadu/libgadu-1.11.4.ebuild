# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils

DESCRIPTION="This library implements the client side of the Gadu-Gadu protocol"
HOMEPAGE="http://toxygen.net/libgadu/"
SRC_URI="https://github.com/wojtekka/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

# Bug 373215, last checked 2012.01.28
RESTRICT="test"

LICENSE="LGPL-2.1"
KEYWORDS="alpha amd64 arm ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
SLOT="0"
IUSE="doc gnutls ssl static-libs threads"

REQUIRED_USE="
	gnutls? ( ssl )
"
COMMON_DEPEND="
	sys-libs/zlib
	ssl? (
		gnutls? ( net-libs/gnutls )
		!gnutls? ( >=dev-libs/openssl-0.9.6m:0 )
	)
"
DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )
"
RDEPEND="${COMMON_DEPEND}
	!=net-im/kadu-0.6.0.2
	!=net-im/kadu-0.6.0.1
"

AUTOTOOLS_IN_SOURCE_BUILD=1

DOCS=(AUTHORS ChangeLog NEWS README)

src_configure() {
	local myeconfargs=(
		$(use_with threads pthread)
	)

	if use ssl; then
		myeconfargs+=(
			$(use_with gnutls gnutls)
			$(use_with !gnutls openssl)
		)
	else
		myeconfargs+=(
			--without-gnutls
			--without-openssl
		)
	fi

	autotools-utils_src_configure
}

src_install() {
	use doc && HTML_DOCS=(docs/html/)
	autotools-utils_src_install
}
