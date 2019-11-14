# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A file archival tool which can also read and write tar files"
HOMEPAGE="https://www.gnu.org/software/cpio/cpio.html"
SRC_URI="mirror://gnu/cpio/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh sparc ~x86 ~ppc-aix ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls"

PATCHES=(
	"${FILESDIR}"/${PN}-2.12-non-gnu-compilers.patch #275295
)

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		--bindir="${EPREFIX}"/bin
		--with-rmt="${EPREFIX}"/usr/sbin/rmt
	)
	econf "${myeconfargs[@]}"
}
