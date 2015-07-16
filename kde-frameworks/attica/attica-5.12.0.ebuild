# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-frameworks/attica/attica-5.12.0.ebuild,v 1.1 2015/07/16 20:33:16 johu Exp $

EAPI=5

inherit kde5

DESCRIPTION="Framework providing access to Open Collaboration Services"
LICENSE="LGPL-2.1+"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-qt/qtnetwork:5
"
DEPEND="${RDEPEND}"
