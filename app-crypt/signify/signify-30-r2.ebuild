# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_METHOD="signify"
inherit toolchain-funcs verify-sig

DESCRIPTION="Cryptographically sign and verify files"
HOMEPAGE="http://www.openbsd.org/ https://github.com/aperezdc/signify"
SRC_URI="
	https://github.com/aperezdc/${PN}/releases/download/v${PV}/${P}.tar.xz
	verify-sig? (
		https://github.com/aperezdc/${PN}/releases/download/v${PV}/SHA256.sig
			-> ${P}.sha.sig
	)"

LICENSE="BSD-1"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="!net-mail/signify
	>=dev-libs/libbsd-0.7"
DEPEND="${RDEPEND}"
BDEPEND="verify-sig? ( sec-keys/signify-keys-signify )"

PATCHES=( "${FILESDIR}"/${PN}-30-man_compress.patch )

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/signify-keys/${P}.pub"

src_unpack() {
	if use verify-sig; then
		# Too many levels of symbolic links
		cp "${DISTDIR}"/${P}.{sha.sig,tar.xz} "${WORKDIR}" || die
		verify-sig_verify_signed_checksums \
			${P}.sha.sig sha256 ${P}.tar.xz
	fi
	default
}

src_configure() {
	tc-export CC
}

src_install() {
	emake DESTDIR="${ED}" PREFIX="/usr" install
	einstalldocs
}
