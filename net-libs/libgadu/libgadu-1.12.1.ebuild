# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libgadu/libgadu-1.12.1.ebuild,v 1.7 2015/08/02 09:11:02 pacho Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils

DESCRIPTION="This library implements the client side of the Gadu-Gadu protocol"
HOMEPAGE="http://toxygen.net/libgadu/"
SRC_URI="https://github.com/wojtekka/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
KEYWORDS="amd64 arm ~mips ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos"
SLOT="0"
IUSE="doc gnutls ssl static-libs test threads"

REQUIRED_USE="
	gnutls? ( ssl )
"
COMMON_DEPEND="
	>=dev-libs/protobuf-c-0.15
	sys-libs/zlib
	ssl? (
		gnutls? ( net-libs/gnutls )
		!gnutls? ( >=dev-libs/openssl-0.9.6m )
	)
"
DEPEND="${COMMON_DEPEND}
	doc? ( app-doc/doxygen )
	test? (
		dev-libs/expat
		dev-libs/libxml2:2
		net-misc/curl
	)
"
RDEPEND="${COMMON_DEPEND}
	!=net-im/kadu-0.6.0.2
	!=net-im/kadu-0.6.0.1
"

AUTOTOOLS_IN_SOURCE_BUILD=1

PATCHES=(
	"${FILESDIR}/${PN}-1.12.0-tests.patch"
)

DOCS=(AUTHORS ChangeLog NEWS README)

src_configure() {
	local myeconfargs=(
		--with-protobuf
		$(use_enable test tests)
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
