# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/utfcpp/utfcpp-2.3.4.ebuild,v 1.1 2015/01/13 20:28:49 yac Exp $

EAPI=5

DESCRIPTION="A simple, portable and lightweight generic library for handling UTF-8 encoded strings."
HOMEPAGE="http://sourceforge.net/projects/utfcpp/"
SRC_URI="mirror://sourceforge/utfcpp/utf8_v${PV//./_}.zip"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/unzip"
RDEPEND=""

S="${WORKDIR}/source"

src_install() {
	doheader utf8.h
	insinto /usr/include/utf8
	doins utf8/{checked,unchecked,core}.h
}
