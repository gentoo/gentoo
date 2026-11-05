# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic

DESCRIPTION="A software PKCS#11 implementation"
HOMEPAGE="https://www.opendnssec.org/"
SRC_URI="https://github.com/softhsm/SoftHSMv2/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/SoftHSMv2-${PV}"

LICENSE="BSD"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="gost migration-tool test"

RESTRICT="!test? ( test )"

RDEPEND="
	migration-tool? ( dev-db/sqlite:3= )
	dev-libs/openssl:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gcc:=[cxx]
	virtual/pkgconfig
	test? ( dev-util/cppunit )
"

DOCS=( NEWS README.md )

PATCHES=(
	"${FILESDIR}"/${P}-byteString2oid-leak.patch
	"${FILESDIR}"/${P}-openssl-4.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# Test failures with LTO (bug #867637)
	append-flags -fno-strict-aliasing
	filter-lto

	econf \
		--with-crypto-backend=openssl \
		--disable-p11-kit \
		--localstatedir="${EPREFIX}/var" \
		--enable-ecc \
		$(use_enable gost) \
		$(use_with migration-tool migrate)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	keepdir /var/lib/softhsm/tokens
}
