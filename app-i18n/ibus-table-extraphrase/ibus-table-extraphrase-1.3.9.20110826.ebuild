# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Chinese extra phrases for IBus-Table"
HOMEPAGE="https://github.com/ibus/ibus/wiki"
SRC_URI="https://ibus.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="app-i18n/ibus-table"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
