# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/kio-locate/kio-locate-0.5.3.ebuild,v 1.3 2014/03/20 22:14:36 johu Exp $

EAPI=5

KDE_LINGUAS="cs de el fr"
KDE_HANDBOOK="optional"
inherit kde4-base

DESCRIPTION="Locate KIO slave for KDE"
HOMEPAGE="http://www.kde-apps.org/content/show.php/kio-locate?content=120965"
SRC_URI="http://www.kde-apps.org/CONTENT/content-files/120965-${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DOCS=( AUTHORS ChangeLog )
PATCHES=( "${FILESDIR}/${P}-gcc-4.7.patch" )

RDEPEND="${RDEPEND}
	sys-apps/mlocate
"
