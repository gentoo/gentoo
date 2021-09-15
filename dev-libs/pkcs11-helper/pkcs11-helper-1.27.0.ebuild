# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="PKCS#11 helper library"
HOMEPAGE="https://github.com/OpenSC/pkcs11-helper"

if [[ $(ver_cut 3) -eq 0 ]]; then
	MY_PV=$(ver_cut 1-2)
else
	MY_PV=${PV}
fi

SRC_URI="https://github.com/OpenSC/${PN}/releases/download/${PN}-${MY_PV}/${P}.tar.bz2"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="bindist doc gnutls nss static-libs"

RDEPEND="
	>=dev-libs/openssl-0.9.7:0=[bindist(-)=]
	gnutls? ( >=net-libs/gnutls-1.4.4 )
	nss? ( dev-libs/nss )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig
	doc? ( >=app-doc/doxygen-1.4.7 )"

PATCHES=(
	"${FILESDIR}/${P}-nss.patch"
)

src_configure() {
	econf \
		--disable-crypto-engine-polarssl \
		--disable-crypto-engine-mbedtls \
		$(use_enable doc) \
		$(use_enable gnutls crypto-engine-gnutls) \
		$(use_enable nss crypto-engine-nss) \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
