# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="Port of libtls from LibreSSL to OpenSSL"
HOMEPAGE="https://git.causal.agency/libretls/about/"
SRC_URI="https://causal.agency/libretls/${P}.tar.gz"

LICENSE="ISC"
SLOT="0/22"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"

DEPEND="dev-libs/openssl:="
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

multilib_src_configure() {
	local myconf=(
		--disable-static
	)
	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
