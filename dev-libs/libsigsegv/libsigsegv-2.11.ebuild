# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Library for handling page faults in user mode"
HOMEPAGE="https://www.gnu.org/software/libsigsegv/"
SRC_URI="mirror://gnu/libsigsegv/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

src_configure () {
	econf --enable-shared
}

src_test () {
	if [[ ${FEATURES} = *sandbox* ]] ; then
		# skip tests as they will fail
		ewarn "Skipped tests. Please disable sandbox to run tests."
		return 0
	fi
	emake check
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog* NEWS PORTING README
}
