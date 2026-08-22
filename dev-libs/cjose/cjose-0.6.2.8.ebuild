# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit autotools

DESCRIPTION="C library implementing the Javascript Object Signing and Encryption (JOSE)"
HOMEPAGE="https://github.com/OpenIDC/cjose"
SRC_URI="https://github.com/OpenIDC/cjose/releases/download/v${PV}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	>=dev-libs/jansson-2.11:=
	>=dev-libs/openssl-1.0.2u:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( >=app-text/doxygen-1.9.8 )
	test? ( >=dev-libs/check-0.9.4 )
"

src_prepare() {
	default

	# Remove -Werror from the build, bug #922461
	sed -e 's/ -Werror//' -i src/Makefile.{am,in} || die

	eautoreconf --force --install
}

src_configure() {
	local myconf=(
		$(use_enable doc doxygen-doc)
	)
	econf "${myconf[@]}"
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
