# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Cryptographic library for EAC version 2"
HOMEPAGE="https://frankmorgner.github.io/openpace"
SRC_URI="https://github.com/frankmorgner/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/3"
KEYWORDS="~amd64 ~x86"

BDEPEND="
	dev-util/gengetopt
	sys-apps/help2man
	virtual/pkgconfig"
DEPEND="dev-libs/openssl:="
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-openssl-3.0-1.patch
	"${FILESDIR}"/${P}-openssl-3.0-2.patch
	"${FILESDIR}"/${P}-openssl-3.0-3.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-openssl-install \
		--disable-go \
		--disable-java \
		--disable-python \
		--disable-ruby
}

src_compile() {
	# not running just 1 job causes a race condition that causes a linking error
	emake -j1
}

src_install() {
	default

	find "${ED}" -type f -name '*.la' -delete || die
}
