# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxqt-base/lxqt-policykit/lxqt-policykit-0.7.0-r1.ebuild,v 1.6 2015/01/30 16:32:20 kensington Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="LXQt PolKit authentication agent"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
else
	SRC_URI="http://downloads.lxqt.org/lxqt/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
	S=${WORKDIR}
fi

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"

RDEPEND="dev-qt/qtcore:4
	dev-qt/qtdbus:4
	dev-qt/qtgui:4
	~lxqt-base/liblxqt-${PV}
	~dev-libs/libqtxdg-0.5.3
	sys-auth/polkit-qt[qt4(-)]
	x11-libs/libX11"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_install(){
	cmake-utils_src_install
	doman man/*.1
}
