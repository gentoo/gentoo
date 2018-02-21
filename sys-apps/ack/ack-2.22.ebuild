# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=PETDANCE
inherit perl-module

DESCRIPTION="ack is a tool like grep, optimized for programmers"
HOMEPAGE="https://beyondgrep.com/ ${HOMEPAGE}"

LICENSE="Artistic-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="test"

RDEPEND=">=dev-perl/File-Next-1.160.0"
DEPEND="${RDEPEND}
	test? ( dev-perl/IO-Tty )"

PATCHES=( "${FILESDIR}"/${PN}-2.14-gentoo.patch )

src_test() {
	# Tests fail when run in parallel and if dev-perl/IO-Tty is installed
	# which enables interactive tests that need to read from stdin. If IO-Tty
	# is not installed the related tests are skipped.
	MAKEOPTS+=" -j1" perl-module_src_test
}
