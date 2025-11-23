# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Chinese extra phrases for IBus-Table"
HOMEPAGE="https://github.com/ibus/ibus/wiki"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/ibus/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="app-i18n/ibus-table"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"
