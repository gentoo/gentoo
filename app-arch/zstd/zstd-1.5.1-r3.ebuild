# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal toolchain-funcs usr-ldscript

DESCRIPTION="zstd fast compression library"
HOMEPAGE="https://facebook.github.io/zstd/"
SRC_URI="https://github.com/facebook/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0/1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="lz4 static-libs split-usr +threads"

RDEPEND="app-arch/xz-utils
	lz4? ( app-arch/lz4 )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.5.1-respect-CFLAGS.patch
)

src_prepare() {
	default
	multilib_copy_sources
}

mymake() {
	# We need to turn off asm for certain arches (!amd64) for now.
	# - bug #829849
	# - https://bugzilla.redhat.com/show_bug.cgi?id=2035802
	# - https://github.com/facebook/zstd/issues/2963
	local asm="ZSTD_NO_ASM=1"

	if use amd64 && [[ ${ABI} == amd64 ]] ; then
		asm=
	fi

	emake \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		AR="$(tc-getAR)" \
		PREFIX="${EPREFIX}/usr" \
		LIBDIR="${EPREFIX}/usr/$(get_libdir)" \
		V=1 \
		${asm} \
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
		gen_usr_ldscript -a zstd

		mymake -C contrib/pzstd DESTDIR="${D}" install
	fi
}

multilib_src_install_all() {
	einstalldocs

	if ! use static-libs; then
		find "${ED}" -name "*.a" -delete || die
	fi
}
