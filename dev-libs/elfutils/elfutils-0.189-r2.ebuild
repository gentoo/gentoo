# Copyright 2003-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/elfutils.gpg
inherit autotools flag-o-matic multilib-minimal verify-sig

DESCRIPTION="Libraries/utilities to handle ELF objects (drop in replacement for libelf)"
HOMEPAGE="https://sourceware.org/elfutils/"
SRC_URI="https://sourceware.org/elfutils/ftp/${PV}/${P}.tar.bz2"
SRC_URI+=" https://dev.gentoo.org/~sam/distfiles/${CATEGORY}/${PN}/${PN}-0.187-patches.tar.xz"
SRC_URI+=" verify-sig? ( https://sourceware.org/elfutils/ftp/${PV}/${P}.tar.bz2.sig )"

LICENSE="|| ( GPL-2+ LGPL-3+ ) utils? ( GPL-3+ )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="bzip2 debuginfod lzma nls static-libs test +utils zstd"
RESTRICT="!test? ( test )"

RDEPEND="
	!dev-libs/libelf
	>=sys-libs/zlib-1.2.8-r1[static-libs?,${MULTILIB_USEDEP}]
	bzip2? ( >=app-arch/bzip2-1.0.6-r4[static-libs?,${MULTILIB_USEDEP}] )
	debuginfod? (
		app-arch/libarchive:=
		dev-db/sqlite:3=
		net-libs/libmicrohttpd:=

		net-misc/curl[static-libs?,${MULTILIB_USEDEP}]
	)
	lzma? ( >=app-arch/xz-utils-5.0.5-r1[static-libs?,${MULTILIB_USEDEP}] )
	zstd? ( app-arch/zstd:=[static-libs?,${MULTILIB_USEDEP}] )
	elibc_musl? (
		dev-libs/libbsd
		sys-libs/argp-standalone
		sys-libs/fts-standalone
		sys-libs/obstack-standalone
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND="
	>=sys-devel/flex-2.5.4a
	sys-devel/m4
	nls? ( sys-devel/gettext )
	verify-sig? ( sec-keys/openpgp-keys-elfutils )
"

PATCHES=(
	"${WORKDIR}"/${PN}-0.187-patches/
	"${FILESDIR}"/${P}-configure-bashisms.patch
	"${FILESDIR}"/${P}-clang16-tests.patch
)

src_unpack() {
	if use verify-sig ; then
		# Needed for downloaded patch (which is unsigned, which is fine)
		verify-sig_verify_detached "${DISTDIR}"/${P}.tar.bz2{,.sig}
	fi

	default
}

src_prepare() {
	default

	if use elibc_musl; then
		eapply "${WORKDIR}"/${PN}-0.187-patches/musl/
	fi

	# Only here for ${P}-configure-bashisms.patch, delete on next bump!
	eautoreconf

	if ! use static-libs; then
		sed -i -e '/^lib_LIBRARIES/s:=.*:=:' -e '/^%.os/s:%.o$::' lib{asm,dw,elf}/Makefile.in || die
	fi

	# https://sourceware.org/PR23914
	sed -i 's:-Werror::' */Makefile.in || die
}

src_configure() {
	# bug #407135
	use test && append-flags -g

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable nls)
		$(multilib_native_use_enable debuginfod)
		$(use_enable debuginfod libdebuginfod)

		# explicitly disable thread safety, it's not recommended by upstream
		# doesn't build either on musl.
		--disable-thread-safety

		# Valgrind option is just for running tests under it; dodgy under sandbox
		# and indeed even w/ glibc with newer instructions.
		--disable-valgrind
		--program-prefix="eu-"
		--with-zlib
		$(use_with bzip2 bzlib)
		$(use_with lzma)
		$(use_with zstd)
	)

	# Needed because sets alignment macro
	is-flagq -fsanitize=address && myeconfargs+=( --enable-sanitize-address )
	is-flagq -fsanitize=undefined && myeconfargs+=( --enable-sanitize-undefined )

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_test() {
	env LD_LIBRARY_PATH="${BUILD_DIR}/libelf:${BUILD_DIR}/libebl:${BUILD_DIR}/libdw:${BUILD_DIR}/libasm" \
		LC_ALL="C" \
		emake check VERBOSE=1
}

multilib_src_install_all() {
	einstalldocs

	dodoc NOTES

	# These build quick, and are needed for most tests, so don't
	# disable their building when the USE flag is disabled.
	if ! use utils; then
		rm -rf "${ED}"/usr/bin || die
	fi
}
