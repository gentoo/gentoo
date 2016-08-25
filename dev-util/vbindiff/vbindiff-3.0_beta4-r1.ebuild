# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Visual binary diff utility"
HOMEPAGE="http://www.cjmweb.net/vbindiff/"
SRC_URI="http://www.cjmweb.net/vbindiff/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86 ~x86-fbsd"
IUSE="debug"

RDEPEND="sys-libs/ncurses:0="
DEPEND="${RDEPEND}"

src_configure() {
	has_version 'sys-libs/ncurses:0[tinfo(-)]' && \
		local -x LIBS="${LIBS} -ltinfo"
	econf $(use_enable debug)
}
