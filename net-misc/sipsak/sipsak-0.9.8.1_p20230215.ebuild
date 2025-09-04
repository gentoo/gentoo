# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

COMMIT_HASH="429325a976788e389ca465e1449153d991754a17"
DESCRIPTION="Small command line tool for testing SIP applications and devices"
HOMEPAGE="https://github.com/nils-ohlmeier/sipsak"
SRC_URI="https://github.com/nils-ohlmeier/sipsak/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/openssl:=
	net-dns/c-ares:=
"
DEPEND="${RDEPEND}
	test? ( dev-libs/check )
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-0.9.8.1-force_openssl.patch
)

src_prepare() {
	default
	append-cppflags -D_GNU_SOURCE
	eautoreconf
}
