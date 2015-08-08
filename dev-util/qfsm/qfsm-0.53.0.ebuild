# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

MY_P="${P}-Source"

inherit cmake-utils

DESCRIPTION="A graphical tool for designing finite state machines"
HOMEPAGE="http://qfsm.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="sys-libs/zlib
	>=dev-qt/qtcore-4.7:4
	>=dev-qt/qt3support-4.7:4
	>=dev-qt/qtsvg-4.7:4
	<media-gfx/graphviz-2.28.0"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS=( ChangeLog README TODO )

# TODO: fix doc building, probably some dependencies are missing
src_prepare()
{
	# remove broken pre-generated Makefile
	rm Makefile || die 'rm Makefile failed'
	# fix desktop files
	sed -i  -e '/Encoding/d' \
		-e 's/\.png//' \
		desktop/qfsm.desktop || die 'sed on qfsm.desktop failed'
	# fix doc path installation, bug #130641
	sed -i -e "s:share/doc/qfsm:share/doc/${P}/html:g" CMakeLists.txt || die 'sed on CMakeLists.txt failed'
}
