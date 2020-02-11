# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Library for handling page faults in user mode"
HOMEPAGE="https://www.gnu.org/software/libsigsegv/"
SRC_URI="mirror://gnu/libsigsegv/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
IUSE=""

PATCHES=(
	# Bug #363503
	"${FILESDIR}/${P}-skip-stackoverflow-tests.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure () {
	econf --enable-shared
}

src_test () {
	emake check
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog* NEWS PORTING README
}
