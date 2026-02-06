# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson verify-sig

DESCRIPTION="C library and code generator for Varlink"
HOMEPAGE="https://gitlab.freedesktop.org/emersion/vali"
SRC_URI="https://gitlab.freedesktop.org/emersion/vali/-/releases/v${PV}/downloads/${P}.tar.gz
	https://gitlab.freedesktop.org/emersion/vali/-/releases/v${PV}/downloads/${P}.tar.gz.sig"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

DEPEND="
	dev-libs/aml
	dev-libs/json-c:=
"
RDEPEND="${DEPEND}"
BDEPEND="
	virtual/pkgconfig
	verify-sig? ( sec-keys/openpgp-keys-emersion )
"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/emersion.asc"
