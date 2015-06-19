# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/mkvalidator/mkvalidator-0.4.0.ebuild,v 1.2 2013/08/14 12:55:37 patrick Exp $

EAPI=4

inherit eutils

DESCRIPTION="mkvalidator is a command line tool to verify Matroska files for spec conformance"
HOMEPAGE="http://www.matroska.org/downloads/mkvalidator.html"
SRC_URI="http://downloads.sourceforge.net/project/matroska/${PN}/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_configure() {
	./configure  # non-standard configure

	# fixing generated makefiles
	sed -i -e 's|^\(LFLAGS.*+=.*\$(LIBS)\)|\1 \$(LDFLAGS)|g' \
		-e 's|^\(STRIP.*=\)|\1 echo|g' $(find -name "*.mak")
}

src_compile() {
	emake -j1
}

src_install() {
	dobin release/*/mkv*
	newdoc ChangeLog.txt ChangeLog
	newdoc ReadMe.txt README
}
