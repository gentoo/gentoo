# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit base flag-o-matic

DESCRIPTION="RTF to HTML converter"
HOMEPAGE="http://rtf2html.sourceforge.net/"
SRC_URI="mirror://sourceforge/rtf2html/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

DEPEND=""
RDEPEND="${DEPEND}"

DOCS=( ChangeLog README )

PATCHES=( "${FILESDIR}/${P}-gcc43.patch" )

src_prepare() {
	# CFLAGS are incorrectly parsed, so handle this here
	sed -i -e '/CFLAGS=$(echo $CFLAGS/d' configure || die 'sed on configure failed'
	use !debug && filter-flags "-g*"

	base_src_prepare
}

src_configure() {
	econf $(use_enable debug)
}
