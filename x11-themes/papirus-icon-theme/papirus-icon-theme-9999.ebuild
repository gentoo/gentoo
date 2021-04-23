# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

DESCRIPTION="Free and open source SVG icon theme"
HOMEPAGE="https://github.com/PapirusDevelopmentTeam/papirus-icon-theme"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/PapirusDevelopmentTeam/papirus-icon-theme.git"
else
	SRC_URI="https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

src_compile() { :; }

src_install() {
	insinto /usr/share/icons
	doins -r ePapirus Papirus{,-Dark,-Light}
}
