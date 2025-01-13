# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Qt frontend to nmap"
HOMEPAGE="https://github.com/nmapsi4/nmapsi4"

if [[ ${PV} = *_p* ]]; then
		COMMIT="463e5cdb516dc68d67b29f6815192cb161e4f7f3"
		SRC_URI="https://github.com/nmapsi4/nmapsi4/archive/${COMMIT}.tar.gz
			-> ${PN}-${COMMIT}.tar.gz"
		S="${WORKDIR}/${PN}4-${COMMIT}"
else
		SRC_URI="https://github.com/nmapsi4/nmapsi4/archive/v${PV/_/-}.tar.gz
			-> ${P}.tar.gz"
		S="${WORKDIR}/${PN}4-${PV/_/-}"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-qt/qtbase:6[dbus,gui,network,widgets]
	dev-qt/qtdeclarative:6
	dev-qt/qtwebengine:6[widgets]
	dev-qt/qt5compat:6
"
RDEPEND="${DEPEND}
	net-analyzer/nmap
	net-dns/bind-tools
"
BDEPEND="dev-qt/qttools:6[linguist]"

DOCS=( AUTHORS HACKING README.md TODO Translation )
