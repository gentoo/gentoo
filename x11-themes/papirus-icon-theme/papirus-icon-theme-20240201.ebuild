# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit xdg

DESCRIPTION="Free and open source SVG icon theme"
HOMEPAGE="https://github.com/PapirusDevelopmentTeam/papirus-icon-theme"
SRC_URI="https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86"

src_compile() { :; }
