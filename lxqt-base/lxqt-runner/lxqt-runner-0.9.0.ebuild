# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxqt-base/lxqt-runner/lxqt-runner-0.9.0.ebuild,v 1.2 2015/04/15 07:06:09 dlan Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="LXQt quick launcher"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
else
	SRC_URI="http://downloads.lxqt.org/lxqt/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"

RDEPEND="dev-libs/glib:2
	>=dev-libs/libqtxdg-1.0.0
	dev-qt/linguist-tools:5
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtscript:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	dev-qt/qtx11extras:5
	dev-qt/qtxml:5
	kde-frameworks/kwindowsystem:5
	~lxqt-base/liblxqt-${PV}
	~lxqt-base/lxqt-globalkeys-${PV}
	>=lxde-base/menu-cache-0.5.1"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install(){
	cmake-utils_src_install
	doman man/*.1
}
