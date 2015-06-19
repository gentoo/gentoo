# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxqt-base/lxqt-common/lxqt-common-0.7.0.ebuild,v 1.5 2015/01/30 16:32:19 kensington Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="LXQt common resources"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
else
	SRC_URI="http://downloads.lxqt.org/lxqt/lxqt/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~x86"
fi

LICENSE="LGPL-2.1+"
SLOT="0"

S=${WORKDIR}

DEPEND="~lxqt-base/liblxqt-${PV}
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	dev-qt/qtsvg:4"
RDEPEND="${DEPEND}"
PDEPEND="~lxqt-base/lxqt-session-${PV}"

src_install() {
	cmake-utils_src_install
	dodir "/etc/X11/Sessions"
	dosym  "/usr/bin/startlxqt" "/etc/X11/Sessions/lxqt"
}
