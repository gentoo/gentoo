# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="Create identical zip archives over multiple systems"
HOMEPAGE="https://sourceforge.net/projects/trrntzip"
SRC_URI="http://dev.gentoo.org/~monsieurp/packages/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	sys-libs/zlib"

DEPEND="
	${RDEPEND}
	app-arch/unzip"

DOCS=(README AUTHORS)

src_prepare() {
	default
	export CPPFLAGS+=" -DOF\\(args\\)=args"
	eautoreconf
}
