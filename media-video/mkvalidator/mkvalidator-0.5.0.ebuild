# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit toolchain-funcs

DESCRIPTION="mkvalidator is a command line tool to verify Matroska files for spec conformance"
HOMEPAGE="http://www.matroska.org/downloads/mkvalidator.html"
SRC_URI="http://downloads.sourceforge.net/project/matroska/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_configure() {
	tc-export CC CXX
	# non-standard configure
	./configure || die

	# fixing generated makefiles
	sed -i -e 's|^\(LFLAGS.*+=.*\$(LIBS)\)|\1 \$(LDFLAGS)|g' \
		-e 's|^\(STRIP.*=\)|\1 echo|g' $(find -name "*.mak") || die
}

src_compile() {
	emake -j1 V=1
}

src_install() {
	dobin release/*/mkv*
	newdoc ChangeLog.txt ChangeLog
	newdoc ReadMe.txt README
}
