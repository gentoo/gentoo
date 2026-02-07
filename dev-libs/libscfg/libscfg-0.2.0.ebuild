# Copyright 2024-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson verify-sig

DESCRIPTION="C library for a simple configuration file format"
HOMEPAGE="https://codeberg.org/emersion/libscfg"
SRC_URI="https://codeberg.org/emersion/${PN}/releases/download/v${PV}/${P}.tar.gz -> ${P}.cb.tar.gz
	https://codeberg.org/emersion/${PN}/releases/download/v${PV}/${P}.tar.gz.sig -> ${P}.cb.tar.gz.sig"

LICENSE="MIT"
SLOT="0/2"
KEYWORDS="~amd64 ~arm64 ~x86"

BDEPEND="
	verify-sig? ( sec-keys/openpgp-keys-emersion )
"

VERIFY_SIG_OPENPGP_KEY_PATH="/usr/share/openpgp-keys/emersion.asc"
