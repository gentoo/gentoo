# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/lxqt-base/libsysstat/libsysstat-0.3.0.ebuild,v 1.2 2015/04/03 10:27:09 dlan Exp $

EAPI=5
inherit cmake-utils

DESCRIPTION="A Qt-based interface to system statistics"
HOMEPAGE="http://lxqt.org/"

if [[ ${PV} = *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.lxde.org/git/lxde/${PN}.git"
else
	SRC_URI="http://downloads.lxqt.org/${PN}/${PV}/${P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~x86"
fi

LICENSE="GPL-2 LGPL-2.1+"
SLOT="0"

DEPEND="
	dev-qt/linguist-tools:5
	dev-qt/qtcore:5
"
RDEPEND="${DEPEND}"
