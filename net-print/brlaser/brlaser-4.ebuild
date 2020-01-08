# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Brother laser printer driver"
HOMEPAGE="https://github.com/pdewacht/brlaser"
SRC_URI="https://github.com/pdewacht/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="net-print/cups"
RDEPEND="
	${DEPEND}
	app-text/ghostscript-gpl"
