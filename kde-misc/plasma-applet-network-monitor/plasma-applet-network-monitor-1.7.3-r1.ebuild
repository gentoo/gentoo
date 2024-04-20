# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit ecm

if [[ ${PV} = *9999* ]] ; then
	EGIT_REPO_URI="https://github.com/kotelnik/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/kotelnik/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64"
fi

DESCRIPTION="Plasma 5 applet for monitoring active network connections"
HOMEPAGE="https://store.kde.org/p/998914/
https://github.com/kotelnik/plasma-applet-network-monitor"

LICENSE="GPL-2+"
SLOT="5"
IUSE=""

DEPEND=">=kde-plasma/libplasma-5.60.0:5"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-crashfix-startuptime.patch"
	"${FILESDIR}/${P}-ddwrt-icon.patch"
)
