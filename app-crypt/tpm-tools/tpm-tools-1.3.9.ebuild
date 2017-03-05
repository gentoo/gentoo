# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils flag-o-matic

DESCRIPTION="TrouSerS' support tools for the Trusted Platform Modules"
HOMEPAGE="http://trousers.sourceforge.net"
SRC_URI="mirror://sourceforge/trousers/${PN}/${P}.tar.gz"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~m68k ~s390 ~sh x86"
IUSE="libressl nls pkcs11 debug"

COMMON_DEPEND="
	>=app-crypt/trousers-0.3.0
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	pkcs11? ( dev-libs/opencryptoki )
	"
RDEPEND="${COMMON_DEPEND}
	nls? ( virtual/libintl )"
DEPEND="${COMMON_DEPEND}
	nls? ( sys-devel/gettext )"

PATCHES=(
	"${FILESDIR}/${P}-gold.patch"
)

S="${WORKDIR}"

src_prepare() {
	default

	sed -i -r \
		-e '/CFLAGS/s/ -m64//' \
		configure.ac || die

	eautoreconf
}

src_configure() {
	append-cppflags $(usex debug -DDEBUG -DNDEBUG)

	econf \
		$(use_enable nls) \
		$(use pkcs11 || echo --disable-pkcs11-support)
}

src_install() {
	default
	prune_libtool_files
}
