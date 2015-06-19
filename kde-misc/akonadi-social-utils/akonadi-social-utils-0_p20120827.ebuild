# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/akonadi-social-utils/akonadi-social-utils-0_p20120827.ebuild,v 1.3 2014/03/20 21:47:24 johu Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="Akonadi library for social communities"
HOMEPAGE="http://quickgit.kde.org/index.php?p=scratch%2Fmklapetek%2Fakonadi-social-utils.git&a=summary"
SRC_URI="http://dev.gentoo.org/~johu/distfiles/${P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="
	$(add_kdebase_dep kdepimlibs 'semantic-desktop(+)')
	dev-libs/qjson
"
DEPEND="
	${RDEPEND}
	x11-misc/shared-mime-info
"

S=${WORKDIR}
