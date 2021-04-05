# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="${PN}_linux_debian"
S="${WORKDIR}/adom"

DESCRIPTION="Ancient Domains Of Mystery rogue-like game"
HOMEPAGE="https://www.adom.de/"
SRC_URI="x86? ( https://www.adom.de/home/download/current/${MY_P}_32_${PV}.tar.gz -> ${P}_x86.tar.gz )
	amd64? ( https://www.adom.de/home/download/current/${MY_P}_64_${PV}.tar.gz -> ${P}_amd64.tar.gz )"

LICENSE="adom"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="strip" # The executable is pre-stripped

DOCS=( "docs/adomfaq.txt"
	"docs/credits.txt"
	"docs/manual.txt"
	"docs/readme1st.txt" )

src_install() {
	exeinto "/opt/bin"
	doexe adom

	einstalldocs
}
