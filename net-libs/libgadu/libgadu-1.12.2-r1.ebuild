# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Client-side library for the Gadu-Gadu protocol"
HOMEPAGE="https://libgadu.net/"
SRC_URI="https://github.com/wojtekka/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~ia64 ~mips ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="doc ssl test threads"

RESTRICT="!test? ( test )"

BDEPEND="
	doc? ( app-doc/doxygen )
	test? (
		dev-libs/expat
		dev-libs/libxml2:2
		net-misc/curl
	)
"
DEPEND="
	dev-libs/protobuf-c:=
	sys-libs/zlib
	ssl? ( net-libs/gnutls:= )
"
RDEPEND="${DEPEND}"

BUILD_DIR="${S}"

PATCHES=(
	"${FILESDIR}/${P}-fno-common.patch"
)

DOCS=( AUTHORS ChangeLog NEWS README )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-static
		--with-protobuf
		--without-openssl
		$(use_with ssl gnutls)
		$(use_enable test tests)
		$(use_with threads pthread)
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	use doc && local HTML_DOCS=( docs/html/. )
	default
	find "${D}" -name '*.la' -type f -delete || die
}
