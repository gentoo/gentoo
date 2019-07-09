# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit kde5

DESCRIPTION="Plasma 5 applet for monitoring active network connections"
HOMEPAGE="https://store.kde.org/p/998914/
https://github.com/kotelnik/plasma-applet-network-monitor"
SRC_URI="https://github.com/kotelnik/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	$(add_frameworks_dep plasma)
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-crashfix-startuptime.patch"
	"${FILESDIR}/${P}-ddwrt-icon.patch"
)
