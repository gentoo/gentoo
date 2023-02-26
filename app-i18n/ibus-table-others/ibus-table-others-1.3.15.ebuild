# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

DESCRIPTION="Various tables for IBus-Table"
HOMEPAGE="https://github.com/moebiuscurve/ibus-table-others"
SRC_URI="https://github.com/moebiuscurve/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-i18n/ibus-table
	!app-i18n/ibus-table-code
	!app-i18n/ibus-table-cyrillic
	!app-i18n/ibus-table-latin
	!app-i18n/ibus-table-tv"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"
