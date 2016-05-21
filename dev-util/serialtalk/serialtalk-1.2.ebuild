# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/BGO-OD/serialtalk.git"
else
	SRC_URI="https://github.com/BGO-OD/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="simple command-line tool to talk to serial devices"
HOMEPAGE="https://github.com/BGO-OD/serialtalk"

LICENSE="GPL-3+"
SLOT="0"

src_install() {
	cmake-utils_src_install
}
