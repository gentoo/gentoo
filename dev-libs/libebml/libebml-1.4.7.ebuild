# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Extensible binary format library (kinda like XML)"
HOMEPAGE="https://www.matroska.org/ https://github.com/Matroska-Org/libebml/"
SRC_URI="https://dl.matroska.org/downloads/${PN}/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0/5" # subslot = soname major version
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc ~ppc64 ~riscv ~sparc ~x86"

DEPEND="dev-libs/utfcpp"
