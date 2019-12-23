# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Zren/${PN}"
else
	SRC_URI="https://github.com/Zren/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Plasma 5 applet for a calendar+agenda with weather that syncs to Google Calendar"
HOMEPAGE="https://store.kde.org/p/998901/
	https://github.com/Zren/plasma-applet-eventcalendar"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

RDEPEND="
	dev-qt/qtgraphicaleffects:5
	kde-plasma/plasma-workspace:5
"

DOCS=( Changelog.md ReadMe.md )

src_install() {
	default
	insinto /usr/share/plasma/plasmoids/org.kde.plasma.eventcalendar
	doins package/metadata.desktop
	doins -r package/{contents,translate}
}
