# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic

DESCRIPTION="A software PKCS#11 implementation"
HOMEPAGE="https://www.opendnssec.org/"
SRC_URI="https://www.opendnssec.org/files/source/${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-2.6.1-patches.tar.xz"

LICENSE="BSD"
SLOT="2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86"
IUSE="gost migration-tool test"

RESTRICT="!test? ( test )"

RDEPEND="
	migration-tool? ( dev-db/sqlite:3= )
	dev-libs/openssl:=
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
	"${WORKDIR}"/${PN}-2.6.1-patches/${PN}-2.6.1-onexit.patch
	"${WORKDIR}"/${PN}-2.6.1-patches/${PN}-2.6.1-openssl3-tests.patch
	"${WORKDIR}"/${PN}-2.6.1-patches/${PN}-2.6.1-uninitialised.patch
	"${WORKDIR}"/${PN}-2.6.1-patches/${PN}-2.6.1-prevent-global-deleted-objects-access.patch
)

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
