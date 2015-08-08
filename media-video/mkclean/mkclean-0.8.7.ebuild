# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="mkclean is a command line tool to clean and optimize Matroska files"
HOMEPAGE="http://www.matroska.org/downloads/mkclean.html"
SRC_URI="http://downloads.sourceforge.net/project/matroska/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_configure() {
	# non-standard configure
	./configure || die

	# fixing generated makefiles
	sed -i -e 's|^\(LFLAGS.*+=.*\$(LIBS)\)|\1 \$(LDFLAGS)|g' \
		-e 's|^\(STRIP.*=\)|\1 echo|g' $(find -name "*.mak") || die
}

src_compile() {
	emake -f GNUmakefile -j1
	emake -C mkclean -f mkWDclean.mak -j1
	emake -C mkclean/regression -f mkcleanreg.mak -j1
}

src_install() {
	dobin release/*/mk*clean*
	newdoc ChangeLog.txt ChangeLog
	newdoc ReadMe.txt README
}
