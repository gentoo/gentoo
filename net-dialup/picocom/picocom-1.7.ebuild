# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils toolchain-funcs

DESCRIPTION="minimal dumb-terminal emulation program"
HOMEPAGE="http://code.google.com/p/picocom/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""

src_prepare() {
	sed -i -e 's:\./picocom:picocom:' pcasc || die
}

src_compile() {
	# CPPFLAGS is shared between CFLAGS and CXXFLAGS, but there is no
	# C++ file, and the pre-processor is never called directly, this
	# is easier than patching it out.
	emake LDFLAGS="${LDFLAGS}" CFLAGS="${CFLAGS} ${CPPFLAGS} -Wall" \
		CC="$(tc-getCC)"
}

src_install() {
	dobin picocom pc{asc,xm,ym,zm}
	doman picocom.8
	dohtml picocom.8.html
	dodoc CHANGES CHANGES.old CONTRIBUTORS README TODO
}
