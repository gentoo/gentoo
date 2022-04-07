# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/gzip.asc
inherit flag-o-matic verify-sig

DESCRIPTION="Standard GNU compressor"
HOMEPAGE="https://www.gnu.org/software/gzip/"
SRC_URI="mirror://gnu/gzip/${P}.tar.xz
	https://alpha.gnu.org/gnu/gzip/${P}.tar.xz"
SRC_URI+=" verify-sig? (
		mirror://gnu/gzip/${P}.tar.xz.sig
		https://alpha.gnu.org/gnu/gzip/${P}.tar.xz.sig
	)"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="pic static"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-gzip )"

PATCHES=(
	"${FILESDIR}/${PN}-1.3.8-install-symlinks.patch"
)

src_configure() {
	use static && append-flags -static

	# Avoid text relocation in gzip
	use pic && export DEFS="NO_ASM"

	# bug #663928
	econf --disable-gcc-warnings
}

src_install() {
	default

	docinto txt
	dodoc algorithm.doc gzip.doc

	# keep most things in /usr, just the fun stuff in /
	dodir /bin
	mv "${ED}"/usr/bin/{gunzip,gzip,uncompress,zcat} "${ED}"/bin/ || die
	sed -e "s:${EPREFIX}/usr:${EPREFIX}:" -i "${ED}"/bin/gunzip || die
}
