# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libqtxdg/libqtxdg-1.0.0.ebuild,v 1.2 2014/11/16 12:40:04 jauhien Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="A Qt implementation of XDG standards"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
else
	SRC_URI="http://lxqt.org/downloads/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="test"

CDEPEND="
	sys-apps/file
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	dev-qt/linguist-tools:5
"
DEPEND="${CDEPEND}
	test? ( dev-qt/qttest:5 )
"
RDEPEND="${CDEPEND}
	x11-misc/xdg-utils
"

src_configure() {
	local mycmakeargs=(
		-DUSE_QT5=ON
		$(cmake-utils_use test BUILD_TESTS)
	)
	cmake-utils_src_configure
}
