# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit toolchain-funcs

DESCRIPTION="Your basic line editor"
HOMEPAGE="https://www.gnu.org/software/ed/"
#SRC_URI="mirror://gnu/ed/${P}.tar.lz"
# Using gzip instead -- the filesize diff is small and lzip uncommon #545344
SRC_URI="http://fossies.org/linux/privat/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~ppc-aix ~x64-cygwin ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="sys-apps/texinfo"
RDEPEND=""

src_configure() {
	# Upstream configure script is moronic.
	econf \
		CC="$(tc-getCC)" \
		CFLAGS="${CFLAGS}" \
		LDFLAGS="${CFLAGS} ${LDFLAGS}" \
		CPPFLAGS="${CPPFLAGS}" \
		--bindir="${EPREFIX}/bin"
}
