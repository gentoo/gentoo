# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="C library implementing the Javascript Object Signing and Encryption (JOSE)"
HOMEPAGE="https://github.com/OpenIDC/cjose"

SRC_URI="https://github.com/OpenIDC/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"

RESTRICT="!test? ( test )"

RDEPEND=">=dev-libs/jansson-2.11:=
	>=dev-libs/openssl-1.0.2u:="
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	doc? ( >=app-text/doxygen-1.8 )
	test? ( >=dev-libs/check-0.9.4 )"

src_prepare() {
	default
	eautoreconf --force --install
}

src_install() {
	default
	find "${ED}" -type f -name '*.la' -delete || die
}
