# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/eventlist/eventlist-0.6-r1.ebuild,v 1.2 2014/04/24 14:10:28 johu Exp $

EAPI=5

MY_P="plasmoid-${P}"
KDE_LINGUAS="cs da de el es et fr ga it km nds nl pl pt pt_BR ru sk sv uk"
inherit kde4-base

DESCRIPTION="Plasmoid showing the events from Akonadi resources"
HOMEPAGE="http://kde-look.org/content/show.php/Eventlist?content=107779"
SRC_URI="http://kde-look.org/CONTENT/content-files/107779-${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64 x86"
IUSE="debug"

RDEPEND="
	$(add_kdebase_dep kdepimlibs)
	|| ( ( $(add_kdebase_dep akonadi) )
	     ( $(add_kdebase_dep kdepim-common-libs) ) )
"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS Changelog README TODO )

S=${WORKDIR}/${MY_P}
