# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit go-module verify-sig

DESCRIPTION="Secure Boot key manager"
HOMEPAGE="https://github.com/Foxboron/sbctl"
SRC_URI="https://github.com/Foxboron/${PN}/releases/download/${PV}/${P}.tar.gz
	https://dev.gentoo.org/~ajak/distfiles/${CATEGORY}/${PN}/${P}-deps.tar.xz
	verify-sig? ( https://github.com/Foxboron/${PN}/releases/download/${PV}/${P}.tar.gz.sig )"

LICENSE="Apache-2.0 BSD BSD-2 MIT"
SLOT="0"
KEYWORDS="amd64"

BDEPEND="app-text/asciidoc
	verify-sig? ( sec-keys/openpgp-keys-foxboron )"

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}/usr/share/openpgp-keys/foxboron.asc"

src_unpack() {
	if use verify-sig; then
		verify-sig_verify_detached "${DISTDIR}"/${P}.tar.gz{,.sig}
	fi

	default
}

src_install() {
	emake PREFIX="${ED}/usr" install
}
