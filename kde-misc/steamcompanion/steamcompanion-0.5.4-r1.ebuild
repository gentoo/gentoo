# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/steamcompanion/steamcompanion-0.5.4-r1.ebuild,v 1.3 2014/08/05 16:31:41 mrueg Exp $

EAPI=5

KDE_LINGUAS="it"
KDE_LINGUAS_DIR="translations"
inherit kde4-base

DESCRIPTION="Connector for web Steam service from Valve"
HOMEPAGE="http://kde-look.org/content/show.php/Steam+Companion?content=141713"
SRC_URI="http://kde-look.org/CONTENT/content-files/141713-${PN}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

S=${WORKDIR}/${PN}
