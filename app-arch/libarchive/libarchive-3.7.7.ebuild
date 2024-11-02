# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit libtool multilib-minimal toolchain-funcs verify-sig

DESCRIPTION="Multi-format archive and compression library"
HOMEPAGE="
	https://www.libarchive.org/
	https://github.com/libarchive/libarchive/
"
SRC_URI="
	https://www.libarchive.de/downloads/${P}.tar.xz
	verify-sig? ( https://www.libarchive.de/downloads/${P}.tar.xz.asc )
"

LICENSE="BSD BSD-2 BSD-4 public-domain"
SLOT="0/13"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ~ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="
	acl blake2 +bzip2 +e2fsprogs expat +iconv lz4 +lzma lzo nettle
	static-libs test xattr +zstd
"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-libs/zlib:=[${MULTILIB_USEDEP}]
	acl? ( virtual/acl:=[${MULTILIB_USEDEP}] )
	blake2? ( app-crypt/libb2:=[${MULTILIB_USEDEP}] )
	bzip2? ( app-arch/bzip2:=[${MULTILIB_USEDEP}] )
	expat? ( dev-libs/expat:=[${MULTILIB_USEDEP}] )
	!expat? ( dev-libs/libxml2:=[${MULTILIB_USEDEP}] )
	iconv? ( virtual/libiconv:=[${MULTILIB_USEDEP}] )
	dev-libs/openssl:=[${MULTILIB_USEDEP}]
	lz4? ( >=app-arch/lz4-0_p131:=[${MULTILIB_USEDEP}] )
	lzma? ( >=app-arch/xz-utils-5.2.5-r1:=[${MULTILIB_USEDEP}] )
	lzo? ( >=dev-libs/lzo-2:=[${MULTILIB_USEDEP}] )
	nettle? ( dev-libs/nettle:=[${MULTILIB_USEDEP}] )
	zstd? ( app-arch/zstd:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	kernel_linux? (
		virtual/os-headers
		e2fsprogs? ( sys-fs/e2fsprogs[${MULTILIB_USEDEP}] )
	)
	test? (
		app-arch/lrzip
		app-arch/lz4
		app-arch/lzip
		app-arch/lzop
		app-arch/xz-utils
		app-arch/zstd
		lzma? ( app-arch/xz-utils[extra-filters(+)] )
	)
"
BDEPEND="
	verify-sig? ( >=sec-keys/openpgp-keys-libarchive-20221209 )
	elibc_musl? ( sys-libs/queue-standalone )
"

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/libarchive.org.asc

# false positives (checks for libc-defined hash functions)
QA_CONFIG_IMPL_DECL_SKIP=(
	SHA256_Init SHA256_Update SHA256_Final
	SHA384_Init SHA384_Update SHA384_Final
	SHA512_Init SHA512_Update SHA512_Final
)

PATCHES=(
	# https://github.com/libarchive/libarchive/issues/2069
	# (we can simply update the command since we don't support old lrzip)
	"${FILESDIR}/${PN}-3.7.2-lrzip.patch"
)

src_prepare() {
	default

	# Needed for flags to be respected w/ LTO
	elibtoolize
}

multilib_src_configure() {
	export ac_cv_header_ext2fs_ext2_fs_h=$(usex e2fsprogs) #354923

	local myconf=(
		$(use_enable acl)
		$(use_enable static-libs static)
		$(use_enable xattr)
		$(use_with blake2 libb2)
		$(use_with bzip2 bz2lib)
		$(use_with expat)
		$(use_with !expat xml2)
		$(use_with iconv)
		$(use_with lz4)
		$(use_with lzma)
		$(use_with lzo lzo2)
		$(use_with nettle)
		--with-zlib
		$(use_with zstd)

		# Windows-specific
		--without-cng
	)
	if multilib_is_native_abi ; then
		myconf+=(
			--enable-bsdcat="$(tc-is-static-only && echo static || echo shared)"
			--enable-bsdcpio="$(tc-is-static-only && echo static || echo shared)"
			--enable-bsdtar="$(tc-is-static-only && echo static || echo shared)"
			--enable-bsdunzip="$(tc-is-static-only && echo static || echo shared)"
		)
	else
		myconf+=(
			--disable-bsdcat
			--disable-bsdcpio
			--disable-bsdtar
			--disable-bsdunzip
		)
	fi

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_compile() {
	if multilib_is_native_abi ; then
		emake
	else
		emake libarchive.la
	fi
}

src_test() {
	mkdir -p "${T}"/bin || die
	# tests fail when lbzip2[symlink] is used in place of ref bunzip2
	ln -s "${BROOT}/bin/bunzip2" "${T}"/bin || die
	# workaround lrzip broken on 32-bit arches with >= 10 threads
	# https://bugs.gentoo.org/927766
	cat > "${T}"/bin/lrzip <<-EOF || die
		#!/bin/sh
		exec "$(type -P lrzip)" -p1 "\${@}"
	EOF
	chmod +x "${T}/bin/lrzip" || die
	local -x PATH=${T}/bin:${PATH}
	multilib-minimal_src_test
}

multilib_src_test() {
	# sandbox is breaking long symlink behavior
	local -x SANDBOX_ON=0
	local -x LD_PRELOAD=
	# some locales trigger different output that breaks tests
	local -x LC_ALL=C.UTF-8
	emake check
}

multilib_src_install() {
	if multilib_is_native_abi ; then
		emake DESTDIR="${D}" install
	else
		local install_targets=(
			install-includeHEADERS
			install-libLTLIBRARIES
			install-pkgconfigDATA
		)
		emake DESTDIR="${D}" "${install_targets[@]}"
	fi

	# Libs.private: should be used from libarchive.pc instead
	find "${ED}" -type f -name "*.la" -delete || die
	# https://github.com/libarchive/libarchive/issues/1766
	sed -e '/Requires\.private/s:iconv::' \
		-i "${ED}/usr/$(get_libdir)/pkgconfig/libarchive.pc" || die
}
