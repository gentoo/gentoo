# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/vollkorn/vollkorn-2.1.ebuild,v 1.1 2012/11/01 20:18:50 sbriesen Exp $

inherit font

DESCRIPTION="Vollkorn, the free and healthy typeface for bread and butter use"
HOMEPAGE="http://friedrichalthausen.de/?page_id=411"
SRC_URI="http://friedrichalthausen.de/Vollkorn-${PV}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

S="${WORKDIR}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
DOCS="Fontlog.txt"

DEPEND="app-arch/unzip"
RDEPEND=""

# Only installs fonts
RESTRICT="strip binchecks"
