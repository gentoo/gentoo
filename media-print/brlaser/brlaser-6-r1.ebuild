# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Brother laser printer driver"
HOMEPAGE="https://github.com/pdewacht/brlaser"
SRC_URI="https://github.com/pdewacht/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

# test/lest uses Boost-1.0 license
LICENSE="Boost-1.0 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="net-print/cups"
RDEPEND="
	${DEPEND}
	app-text/ghostscript-gpl
"
