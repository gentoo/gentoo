# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multiprocessing

DESCRIPTION="File archival tool which can also read and write tar files"
HOMEPAGE="https://www.gnu.org/software/cpio/cpio.html"
SRC_URI="mirror://gnu/cpio/${P}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="nls"

PDEPEND="
	app-alternatives/cpio
"

PATCHES=(
	"${FILESDIR}"/${PN}-2.12-non-gnu-compilers.patch # bug #275295
)

QA_CONFIG_IMPL_DECL_SKIP=(
	unreachable
	MIN
	alignof
	static_assert
)

src_configure() {
	# https://savannah.gnu.org/bugs/?66297
	append-cflags -std=gnu17

	local myeconfargs=(
		$(use_enable nls)
		--bindir="${EPREFIX}"/bin
		--with-rmt="${EPREFIX}"/usr/sbin/rmt
		# install as gcpio for better compatibility with non-GNU userland
		--program-prefix=g
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	emake check TESTSUITEFLAGS="--jobs=$(get_makeopts_jobs)"
}

pkg_postinst() {
	# Ensure to preserve the symlink before app-alternatives/cpio
	# is installed
	if [[ ! -h ${EROOT}/bin/cpio ]]; then
		ln -s gcpio "${EROOT}/bin/cpio" || die
	fi
}
