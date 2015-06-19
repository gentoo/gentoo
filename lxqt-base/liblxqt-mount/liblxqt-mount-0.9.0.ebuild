# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxqt-base/liblxqt-mount/liblxqt-mount-0.9.0.ebuild,v 1.4 2015/04/15 06:50:11 dlan Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="LXQt library for removable media and devices"
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
IUSE="+udisks"

DEPEND="dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/linguist-tools:5
	~lxqt-base/liblxqt-${PV}
	virtual/udev"
RDEPEND="${DEPEND}
	udisks? ( sys-fs/udisks )"
