# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic

DESCRIPTION="TrouSerS' support tools for the Trusted Platform Modules"
HOMEPAGE="http://trousers.sourceforge.net"
SRC_URI="mirror://sourceforge/trousers/${PN}/${P}.tar.gz"

LICENSE="CPL-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~m68k ~s390 ~x86"
IUSE="nls pkcs11 debug"

DEPEND=">=app-crypt/trousers-0.3.15-r1
	dev-libs/openssl:0=
	pkcs11? ( dev-libs/opencryptoki )"
RDEPEND="${DEPEND}"
BDEPEND="nls? ( sys-devel/gettext )"

src_prepare() {
	default

# upstream didn't generate the tarball correctly so we must bootstrap
# ouselves
	mkdir -p po || die
	mkdir -p m4 || die
	cp -R po_/* po/ || die
	touch po/Makefile.in.in || die
	touch m4/Makefile.am || die

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
	find "${D}" -name '*.la' -delete || die
}
