# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Command-line flags module for Unix shell scripts"
HOMEPAGE="https://github.com/kward/shflags"
SRC_URI="https://github.com/kward/shflags/archive/v${PV}.tar.gz -> ${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86"
IUSE="examples"

src_test() {
	sh test_runner || die
}

src_install() {
	dodoc README* doc/*.txt
	insinto /usr/share/misc
	doins "${PN}"
	use examples && dodoc examples/*
}
