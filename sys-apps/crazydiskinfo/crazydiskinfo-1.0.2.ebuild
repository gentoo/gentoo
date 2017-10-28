# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Interactive TUI S.M.A.R.T viewer"
HOMEPAGE="https://github.com/otakuto/crazydiskinfo"
SRC_URI="https://github.com/otakuto/crazydiskinfo/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="
	dev-libs/libatasmart:0=
	sys-libs/ncurses:0="

RDEPEND="$DEPEND"
