# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Electronic Schematic and PCB design tools GUI translations"
HOMEPAGE="https://gitlab.com/kicad/code/kicad-i18n"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.com/kicad/code/kicad-i18n.git"
	inherit autotools git-r3
	# x11-misc-util/macros only required on live ebuilds
	LIVE_DEPEND=">=x11-misc/util-macros-1.18"
else
	SRC_URI="https://gitlab.com/kicad/code/${PN}/-/archive/${PV}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="CC-BY-SA-4.0"
SLOT="0"
IUSE=""

BDEPEND="sys-devel/gettext"
#RDEPEND=">=sci-electronics/kicad-5.1.6"
