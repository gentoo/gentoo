# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils flag-o-matic

DESCRIPTION="TrouSerS' support tools for the Trusted Platform Modules"
HOMEPAGE="http://trousers.sourceforge.net"
SRC_URI="mirror://sourceforge/trousers/${P}.tar.gz"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~m68k ~s390 ~sh ~x86"
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

src_prepare() {
	sed -i -r \
		-e '/CFLAGS/s/ -(Werror|m64)//' \
		configure.in || die
	epatch "${FILESDIR}/${P}-gold.patch"
	epatch "${FILESDIR}/${P}-build.patch"

	eautoreconf
}

src_configure() {
	local myconf
	# don't use --enable-pkcs11-support, configure is a mess.
	use pkcs11 || myconf+=" --disable-pkcs11-support"

	append-cppflags $(usex debug -DDEBUG -DNDEBUG)

	econf \
		$(use_enable nls) \
		${myconf}
}

src_install() {
	default
	rm -f "${ED}"/usr/lib*/libtpm_unseal.la
}
