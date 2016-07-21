# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit eutils

DESCRIPTION="Improved make"
HOMEPAGE="https://github.com/mohawk2/dmake"
SRC_URI="http://${PN}.apache-extras.org.codespot.com/files/${P}.tar.bz2"

LICENSE="GPL-1"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

# test failure, reported upstream at
# https://code.google.com/a/apache-extras.org/p/dmake/issues/detail?id=1
RESTRICT="test"

DEPEND="
	app-arch/unzip
	sys-apps/groff
"
RDEPEND=""

src_prepare() {
	# make tests executable, bug #404989
	chmod +x tests/targets-{1..12} || die
}

src_install () {
	default
	newman man/dmake.tf dmake.1
}
