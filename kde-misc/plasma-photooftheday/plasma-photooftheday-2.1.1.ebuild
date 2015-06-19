# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/plasma-photooftheday/plasma-photooftheday-2.1.1.ebuild,v 1.1 2013/06/21 22:18:00 creffett Exp $

EAPI=5

inherit kde4-base

LINGUAS="bg de"
CONTENT_NUMBER="104631"

DESCRIPTION="Photo of the Day plasmoid"
HOMEPAGE="http://www.kde-look.org/content/show.php/Photo+of+the+Day?content=104631"
LICENSE="GPL-2+"
IUSE="debug"

KEYWORDS="~amd64 ~x86"
SLOT="4"

SRC_URI="http://kde-look.org/CONTENT/content-files/${CONTENT_NUMBER}-photo-of-the-day.tar.gz -> ${CONTENT_NUMBER}-photo-of-the-day-${PV}.tar.gz"

RDEPEND="
	$(add_kdebase_dep plasma-workspace)
"
DEPEND="${RDEPEND}
	sys-devel/gettext
"

S="${WORKDIR}/photo-of-the-day"
