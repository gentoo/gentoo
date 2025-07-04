# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Utilities for PKCS#11 token content dump"
HOMEPAGE="https://github.com/alonbl/pkcs11-dump"
SRC_URI="https://github.com/alonbl/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-libs/openssl:="
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
