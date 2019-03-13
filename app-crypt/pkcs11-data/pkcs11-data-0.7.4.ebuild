# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Utilities for PKCS#11 data object manipulation in"
HOMEPAGE="https://github.com/alonbl/pkcs11-data"
SRC_URI="https://github.com/alonbl/${PN}/releases/download/${P}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64"

RDEPEND=">=dev-libs/pkcs11-helper-1.02"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
