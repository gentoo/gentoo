# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils

DESCRIPTION="A Qt implementation of XDG standards"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
else
	SRC_URI="http://lxqt.org/downloads/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="test"

CDEPEND="sys-apps/file
	dev-qt/qtcore:4
	dev-qt/qtgui:4"
DEPEND="${CDEPEND}
	test? ( dev-qt/qttest:4 )"
RDEPEND="${CDEPEND}
	x11-misc/xdg-utils"

S=${WORKDIR}

src_configure() {
	local mycmakeargs=(
		$(cmake-utils_use test BUILD_TESTS)
	)
	cmake-utils_src_configure
}
