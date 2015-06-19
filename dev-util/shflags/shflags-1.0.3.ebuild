# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/shflags/shflags-1.0.3.ebuild,v 1.4 2014/07/29 09:35:19 vapier Exp $

EAPI="4"

DESCRIPTION="Command-line flags module for Unix shell scripts"
HOMEPAGE="http://code.google.com/p/shflags/"
SRC_URI="http://shflags.googlecode.com/files/${P}.tgz"

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
