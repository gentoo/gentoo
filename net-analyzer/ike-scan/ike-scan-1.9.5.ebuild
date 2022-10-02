# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A utility for finding, fingerprinting and testing IKE VPN servers"
HOMEPAGE="https://github.com/royhills/ike-scan"
SRC_URI="https://github.com/royhills/ike-scan/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="ssl"

DEPEND="ssl? ( dev-libs/openssl:= )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.9.5-clang-16.patch
<<<<<<< HEAD
	"${FILESDIR}"/${PN}-1.9.5-openssl-libdir.patch
=======
>>>>>>> 3928948a06b (rebase)
)

src_prepare() {
	default

	# Fix buffer overflow, bug #277556
	sed \
		-e "/MAXLINE/s:255:511:g" \
		-i ike-scan.h || die

	eautoreconf
}

src_configure() {
<<<<<<< HEAD
	econf \
		$(use_with ssl openssl "${ESYSROOT}"/usr)
=======
	econf $(use_with ssl openssl)
>>>>>>> 3928948a06b (rebase)
}

src_install() {
	default
	dodoc udp-backoff-fingerprinting-paper.txt
}
