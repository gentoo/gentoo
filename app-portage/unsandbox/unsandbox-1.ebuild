# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="The Sandbox escapist tool"
HOMEPAGE="http://dev.gentoo.org/~mgorny/dist/unsandbox.c"
SRC_URI="http://dev.gentoo.org/~mgorny/dist/unsandbox.c"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S=${WORKDIR}

src_unpack() {
	cp "${DISTDIR}"/unsandbox.c "${WORKDIR}"/ || die
}

src_compile() {
	emake LDLIBS=-ldl unsandbox
}

src_install() {
	dobin unsandbox
}
