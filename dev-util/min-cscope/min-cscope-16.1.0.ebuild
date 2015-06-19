# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/min-cscope/min-cscope-16.1.0.ebuild,v 1.3 2014/02/07 20:41:56 creffett Exp $

EAPI=5
inherit cmake-utils flag-o-matic

DESCRIPTION="Interactively examine a C program"
HOMEPAGE="http://sourceforge.net/projects/kscope/"
SRC_URI="mirror://sourceforge/kscope/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug"

S=${WORKDIR}/${PN}

DOCS="AUTHORS README* TODO"

src_prepare() {
	echo 'INSTALL(TARGETS min-cscope RUNTIME DESTINATION bin)' \
		>> src/CMakeLists.txt
}

src_configure() {
	append-flags -I"${S}/sort"
	cmake-utils_src_configure
}
