# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/plasma-/}"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/psifidotos/${MY_PN}"
else
	SRC_URI="https://github.com/psifidotos/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

DESCRIPTION="Plasma 5 applet that shows the application title and icon for active window"
HOMEPAGE="https://github.com/psifidotos/applet-window-title"

LICENSE="GPL-2+"
SLOT="0"
IUSE=""

RDEPEND="
	kde-frameworks/kdeclarative:5
	kde-plasma/plasma-workspace:5
"

DOCS=( CHANGELOG.md LICENSE README.md )

src_install() {
	default
	insinto /usr/share/plasma/plasmoids/org.kde.windowtitle
	doins metadata.desktop
	doins -r contents
}
