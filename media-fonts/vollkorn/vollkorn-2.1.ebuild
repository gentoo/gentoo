# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit font

DESCRIPTION="Vollkorn, the free and healthy typeface for bread and butter use"
HOMEPAGE="http://friedrichalthausen.de/?page_id=411"
SRC_URI="http://friedrichalthausen.de/Vollkorn-${PV}.zip"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""
# Only installs fonts
RESTRICT="strip binchecks"

BDEPEND="app-arch/unzip"

S="${WORKDIR}"

FONT_S="${S}"
FONT_SUFFIX="ttf"
DOCS="Fontlog.txt"
