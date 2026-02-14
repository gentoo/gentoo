# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson verify-sig

DESCRIPTION="Lightweight KMS plane library"
HOMEPAGE="https://gitlab.freedesktop.org/emersion/libliftoff"
SRC_URI="https://gitlab.freedesktop.org/emersion/${PN}/-/releases/v${PV}/downloads/${P}.tar.gz -> ${P}.gl.tar.gz
	https://gitlab.freedesktop.org/emersion/${PN}/-/releases/v${PV}/downloads/${P}.tar.gz.sig -> ${P}.gl.tar.gz.sig"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~loong ppc64 ~riscv x86"

RDEPEND="
	x11-libs/libdrm
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-emersion )
"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/emersion.asc"
