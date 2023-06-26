# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib elisp-common flag-o-matic toolchain-funcs

if [[ "${PV}" == *9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/protocolbuffers/protobuf.git"
	EGIT_SUBMODULES=()
else
	SRC_URI="https://github.com/protocolbuffers/protobuf/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
fi

DESCRIPTION="Google's Protocol Buffers - Extensible mechanism for serializing structured data"
HOMEPAGE="https://developers.google.com/protocol-buffers/"

LICENSE="BSD"
SLOT=$(ver_cut 3)
SLOT="0/$(ver_cut 1-2).${SLOT:-0}"
IUSE="emacs examples static-libs test zlib"
RESTRICT="!test? ( test )"

BDEPEND="emacs? ( app-editors/emacs:* )"
CDEPEND="
	dev-cpp/abseil-cpp:=[${MULTILIB_USEDEP}]
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )
"
DEPEND="${CDEPEND}
	test? ( >=dev-cpp/gtest-1.9[${MULTILIB_USEDEP}] )
"
RDEPEND="${CDEPEND}
	emacs? ( app-editors/emacs:* )
"

DOCS=( CONTRIBUTORS.txt README.md )

src_prepare() {
	cmake_src_prepare

	# https://github.com/protocolbuffers/protobuf/issues/8082
	sed -e "/^TEST_F(IoTest, LargeOutput) {$/,/^}$/d" -i src/google/protobuf/io/zero_copy_stream_unittest.cc || die

	# https://github.com/protocolbuffers/protobuf/issues/8459
	sed \
		-e "/^TEST(ArenaTest, BlockSizeSmallerThanAllocation) {$/a\\  if (sizeof(void*) == 4) {\n    GTEST_SKIP();\n  }" \
		-e "/^TEST(ArenaTest, SpaceAllocated_and_Used) {$/a\\  if (sizeof(void*) == 4) {\n    GTEST_SKIP();\n  }" \
		-i src/google/protobuf/arena_unittest.cc || die

	# https://github.com/protocolbuffers/protobuf/issues/8460
	sed -e "/^TEST(AnyTest, TestPackFromSerializationExceedsSizeLimit) {$/a\\  if (sizeof(void*) == 4) {\n    GTEST_SKIP();\n  }" -i src/google/protobuf/any_test.cc || die

	# https://github.com/protocolbuffers/protobuf/issues/9433
	sed -e "/^[[:space:]]*static_assert(alignof(U) <= 8, \"\");$/d" -i src/google/protobuf/descriptor.cc || die
}

src_configure() {
	if tc-ld-is-gold; then
		# https://sourceware.org/bugzilla/show_bug.cgi?id=24527
		tc-ld-disable-gold
	fi

	cmake-multilib_src_configure
}

multilib_src_configure() {
	local mycmakeargs=(
		-Dprotobuf_DISABLE_RTTI=ON
		-Dprotobuf_BUILD_TESTS=$(usex test ON OFF)
		$(usex test -Dprotobuf_USE_EXTERNAL_GTEST=ON '')
		-Dprotobuf_ABSL_PROVIDER=package
	)

	cmake_src_configure
}

src_compile() {
	cmake-multilib_src_compile

	if use emacs; then
		elisp-compile editors/protobuf-mode.el
	fi
}

multilib_src_install_all() {
	find "${ED}" -name "*.la" -delete || die

	if [[ ! -f "${ED}/usr/$(get_libdir)/libprotobuf.so.${SLOT#*/}" ]]; then
		eerror "No matching library found with SLOT variable, currently set: ${SLOT}\n" \
			"Expected value: ${ED}/usr/$(get_libdir)/libprotobuf.so.${SLOT#*/}"
		die "Please update SLOT variable"
	fi

	insinto /usr/share/vim/vimfiles/syntax
	doins editors/proto.vim
	insinto /usr/share/vim/vimfiles/ftdetect
	doins "${FILESDIR}/proto.vim"

	if use emacs; then
		elisp-install ${PN} editors/protobuf-mode.el*
		elisp-site-file-install "${FILESDIR}/70${PN}-gentoo.el"
	fi

	if use examples; then
		DOCS+=(examples)
		docompress -x /usr/share/doc/${PF}/examples
	fi

	einstalldocs
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
