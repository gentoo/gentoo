# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Cryptographic library for EAC version 2"
HOMEPAGE="https://frankmorgner.github.io/openpace"
SRC_URI="https://github.com/frankmorgner/openpace/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0/3"
KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ppc64 ~riscv ~s390 ~sparc x86"

BDEPEND="
	dev-util/gengetopt
	sys-apps/help2man
	virtual/pkgconfig"
DEPEND="dev-libs/openssl:="
RDEPEND="${DEPEND}"

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
