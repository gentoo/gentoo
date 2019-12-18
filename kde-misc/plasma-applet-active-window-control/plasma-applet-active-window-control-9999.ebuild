# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3 kde5
	EGIT_REPO_URI="https://github.com/kotelnik/${PN}"
else
	inherit kde5
	SRC_URI="https://github.com/kotelnik/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Plasma 5 applet for controlling currently active window"
HOMEPAGE="https://store.kde.org/p/998910/
	https://github.com/kotelnik/plasma-applet-active-window-control"

LICENSE="GPL-2+"
IUSE=""

DEPEND="
	$(add_frameworks_dep plasma)
"
RDEPEND="${DEPEND}"
