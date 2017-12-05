# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Various tables for IBus-Table"
HOMEPAGE="https://github.com/moebiuscurve/ibus-table-others"
SRC_URI="https://github.com/moebiuscurve/${PN}/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-i18n/ibus-table"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
