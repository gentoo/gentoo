# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/akonadi-facebook/akonadi-facebook-0_p20130209.ebuild,v 1.4 2015/07/28 20:33:00 johu Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="Facebook services integration in Akonadi"
HOMEPAGE="https://projects.kde.org/akonadi-facebook"
SRC_URI="http://dev.gentoo.org/~creffett/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	$(add_kdebase_dep kdepimlibs 'semantic-desktop(+)' 4.9.58)
	dev-libs/qjson
	net-libs/libkfbapi:4
"
DEPEND="
	${RDEPEND}
	dev-libs/boost
	dev-libs/libxslt
	x11-misc/shared-mime-info
"
