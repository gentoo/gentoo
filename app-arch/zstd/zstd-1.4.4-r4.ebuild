# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic multilib-minimal toolchain-funcs

DESCRIPTION="zstd fast compression library"
HOMEPAGE="https://facebook.github.io/zstd/"
SRC_URI="https://github.com/facebook/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0/1"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="lz4 static-libs +threads"

RDEPEND="app-arch/xz-utils
	lz4? ( app-arch/lz4 )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-pkgconfig_libdir.patch" #700780
	"${FILESDIR}/${P}-make43.patch" #708110
)

src_prepare() {
	default
	multilib_copy_sources

	# Workaround #713940 / https://github.com/facebook/zstd/issues/2045
	# where upstream build system does not add -pthread for Makefile-based
	# build system.
	use threads && append-flags $(test-flags-CCLD -pthread)
}

mymake() {
	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		AR="$(tc-getAR)" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		"${@}"
}

multilib_src_compile() {
	local libzstd_targets=( libzstd{,.a}$(usex threads '-mt' '') )

	mymake -C lib ${libzstd_targets[@]} libzstd.pc

	if multilib_is_native_abi ; then
		mymake HAVE_LZ4="$(usex lz4 1 0)" zstd

		mymake -C contrib/pzstd
	fi
}

multilib_src_install() {
	mymake -C lib DESTDIR="${D}" install

	if multilib_is_native_abi ; then
		mymake -C programs DESTDIR="${D}" install

		mymake -C contrib/pzstd DESTDIR="${D}" install
	fi
}

multilib_src_install_all() {
	einstalldocs

	if ! use static-libs; then
		find "${ED}" -name "*.a" -delete || die
	fi
}
