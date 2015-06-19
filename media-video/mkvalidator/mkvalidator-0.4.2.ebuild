# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mkvalidator/mkvalidator-0.4.2.ebuild,v 1.1 2013/06/15 10:40:32 radhermit Exp $

EAPI=5

DESCRIPTION="mkvalidator is a command line tool to verify Matroska files for spec conformance"
HOMEPAGE="http://www.matroska.org/downloads/mkvalidator.html"
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
	emake -j1
}

src_install() {
	dobin release/*/mkv*
	newdoc ChangeLog.txt ChangeLog
	newdoc ReadMe.txt README
}
