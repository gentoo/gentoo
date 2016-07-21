# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Command-line flags module for Unix shell scripts"
HOMEPAGE="https://github.com/kward/shflags"
SRC_URI="https://github.com/kward/shflags/archive/${PV}.tar.gz -> ${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86"
IUSE="examples"

src_test() {
	cd src || die
	./shflags_test.sh || die
}

src_install() {
	dohtml README.html
	dodoc README.txt doc/*.txt
	insinto /usr/share/misc
	doins src/shflags
	use examples && dodoc examples/*.sh
}
