# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

DESCRIPTION="Command-line flags module for Unix shell scripts"
HOMEPAGE="https://code.google.com/p/shflags/"
SRC_URI="https://shflags.googlecode.com/files/${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="examples"

src_test() {
	cd src
	./shflags_test.sh || die
}

src_install() {
	dohtml README.html
	dodoc README.txt doc/*.txt
	insinto /usr/share/misc
	doins src/shflags
	use examples && dodoc examples/*.sh
}
