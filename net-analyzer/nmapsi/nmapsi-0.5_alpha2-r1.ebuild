# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Qt frontend to nmap"
HOMEPAGE="https://github.com/nmapsi4/nmapsi4"
SRC_URI="https://github.com/nmapsi4/nmapsi4/archive/v${PV/_/-}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}4-${PV/_/-}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtwebengine:5[widgets]
	dev-qt/qtwidgets:5
"
RDEPEND="${DEPEND}
	net-analyzer/nmap
	net-dns/bind-tools
"
BDEPEND="dev-qt/linguist-tools:5"

DOCS=( AUTHORS HACKING README.md TODO Translation )

PATCHES=( "${FILESDIR}/${P}-no-qtscript.patch" )
