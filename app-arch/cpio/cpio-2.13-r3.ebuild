# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A file archival tool which can also read and write tar files"
HOMEPAGE="https://www.gnu.org/software/cpio/cpio.html"
SRC_URI="mirror://gnu/cpio/${P}.tar.bz2"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${P}-CVE-2021-38185.patch.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls"

PATCHES=(
	"${FILESDIR}"/${PN}-2.12-non-gnu-compilers.patch #275295
	"${WORKDIR}"/${P}-CVE-2021-38185.patch
	"${FILESDIR}"/${PN}-2.13-sysmacros-glibc-2.26.patch
	"${FILESDIR}"/${PN}-2.13-fix-no-absolute-filenames-revert-CVE-2015-1197-handling.patch
)

src_prepare() {
	default

	# Drop after 2.13 (only here for CVE patch)
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		--bindir="${EPREFIX}"/bin
		--with-rmt="${EPREFIX}"/usr/sbin/rmt
		# install as gcpio for better compatibility with non-GNU userland
		--program-prefix=g
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# make cpio a symlink
	dosym gcpio /bin/cpio
	dosym gcpio.1 /usr/share/man/man1/cpio.1
}
