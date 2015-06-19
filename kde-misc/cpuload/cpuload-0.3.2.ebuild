# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-misc/cpuload/cpuload-0.3.2.ebuild,v 1.2 2014/08/05 16:31:40 mrueg Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="KDE4 plasmoid that shows CPU load on the screen"
HOMEPAGE="http://www.kde-look.org/content/show.php/cpuload?content=86628"
SRC_URI="http://kde-look.org/CONTENT/content-files/86628-${P}.tar.gz"

LICENSE="GPL-2+"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE="debug"

DEPEND="
	$(add_kdebase_dep plasma-workspace)
"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/"${PN}"
