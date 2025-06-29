# Copyright 2024-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="OpenSMTPD filter for signing mail with DKIM"
HOMEPAGE="https://src.imperialat.at/?action=summary&path=filter-dkimsign.git"
SRC_URI="https://src.imperialat.at/releases/filter-dkimsign-${PV}.tar.gz -> ${P}-new.tar.gz"
S=${WORKDIR}/${P#opensmtpd-}

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	>=mail-filter/libopensmtpd-1
	dev-libs/openssl
	"
RDEPEND="${DEPEND}"

src_prepare() {
	default
	mv -f Makefile.gnu Makefile || die
}

src_compile() {
	emake CC="$(tc-getCC)" LIBCRYPTOPC="libcrypto" MANFORMAT="man"
}

src_install() {
	emake DESTDIR="${D}" LIBDIR="/usr/$(get_libdir)" MANFORMAT="man" install
}
