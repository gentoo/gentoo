# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A software PKCS#11 implementation"
HOMEPAGE="https://www.opendnssec.org/"
SRC_URI="https://www.opendnssec.org/files/source/${P}.tar.gz"

LICENSE="BSD"
SLOT="2"
KEYWORDS="~alpha ~amd64 ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="bindist gost libressl migration-tool test"

RESTRICT="!test? ( test )"

RDEPEND="
	migration-tool? ( dev-db/sqlite:3= )
	!libressl? ( dev-libs/openssl:0=[bindist=] )
	libressl? ( dev-libs/libressl:= )
	!~dev-libs/softhsm-2.0.0:0
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/gcc:=[cxx]
	virtual/pkgconfig
	test? ( dev-util/cppunit )
"

DOCS=( NEWS README.md )

PATCHES=(
	"${FILESDIR}/${P}-libressl.patch"
)

src_configure() {
	econf \
		--disable-static \
		--with-crypto-backend=openssl \
		--disable-p11-kit \
		--localstatedir="${EPREFIX}/var" \
		$(use_enable !bindist ecc) \
		$(use_enable gost) \
		$(use_with migration-tool migrate)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die

	keepdir /var/lib/softhsm/tokens
}
