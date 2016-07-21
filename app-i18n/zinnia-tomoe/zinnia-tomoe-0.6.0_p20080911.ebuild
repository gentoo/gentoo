# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

AUTOTOOLS_AUTORECONF=1

inherit autotools-utils multilib

MY_P=${P/_p/-}

DESCRIPTION="Handwriting model files trained with Tomoe data"
HOMEPAGE="http://zinnia.sourceforge.net/index.html"
SRC_URI="mirror://sourceforge/zinnia/${MY_P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="app-i18n/zinnia"
RDEPEND="${DEPEND}"

S="${WORKDIR}"/${MY_P}

AUTOTOOLS_IN_SOURCE_BUILD=1

src_prepare() {
	sed -i -e "/^modeldir/s/lib/$(get_libdir)/" Makefile.am || die
	autotools-utils_src_prepare
}
