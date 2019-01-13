# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="FTP wrapper which supports TLS with every FTP client"
HOMEPAGE="https://www.tlswrap.com/"
SRC_URI="https://www.tlswrap.com/${P}.tar.gz"

# GPL-2 for Gentoo init script
LICENSE="BSD GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="libressl"

RDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:= )
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/respect-cflags.patch"
	"${FILESDIR}/modernize-am_init_automake.patch"
	"${FILESDIR}/fix-Wformat-security-warnings.patch"
	"${FILESDIR}/${P}-openssl11.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	emake prefix="${D}/usr" install
	einstalldocs
	newinitd "${FILESDIR}/tlswrap.init" tlswrap
}
