# Copyright 2008-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools elisp-common flag-o-matic multilib-minimal toolchain-funcs

if [[ "${PV}" == *9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/protocolbuffers/protobuf.git"
	EGIT_SUBMODULES=()
else
	SRC_URI="https://github.com/protocolbuffers/protobuf/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
fi

DESCRIPTION="Google's Protocol Buffers - Extensible mechanism for serializing structured data"
HOMEPAGE="
	https://developers.google.com/protocol-buffers/
"

LICENSE="BSD"
SLOT="0/32"
IUSE="emacs examples static-libs test zlib"
RESTRICT="!test? ( test )"

BDEPEND="emacs? ( app-editors/emacs:* )"
DEPEND="test? ( >=dev-cpp/gtest-1.9[${MULTILIB_USEDEP}] )
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )"
RDEPEND="emacs? ( app-editors/emacs:* )
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )"

PATCHES=(
	"${FILESDIR}/${PN}-3.19.0-disable_no-warning-test.patch"
	"${FILESDIR}/${PN}-3.19.0-system_libraries.patch"
	"${FILESDIR}/${PN}-3.20.2-protoc_input_output_files.patch"
)

DOCS=(CHANGES.txt CONTRIBUTORS.txt README.md)

src_prepare() {
	default

	# https://github.com/protocolbuffers/protobuf/issues/7413
	sed -e "/^AC_PROG_CXX_FOR_BUILD$/d" -i configure.ac || die

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

	eautoreconf
}

src_configure() {
	append-cppflags -DGOOGLE_PROTOBUF_NO_RTTI

	if tc-ld-is-gold; then
		# https://sourceware.org/bugzilla/show_bug.cgi?id=24527
		tc-ld-disable-gold
	fi

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local options=(
		$(use_enable static-libs static)
		$(use_with zlib)
	)

	if tc-is-cross-compiler; then
		# Build system uses protoc when building, so protoc copy runnable on host is needed.
		mkdir -p "${WORKDIR}/build" || die
		pushd "${WORKDIR}/build" > /dev/null || die
		ECONF_SOURCE="${S}" econf_build "${options[@]}"
		options+=(--with-protoc="$(pwd)/src/protoc")
		popd > /dev/null || die
	fi

	ECONF_SOURCE="${S}" econf "${options[@]}"
}

src_compile() {
	multilib-minimal_src_compile

	if use emacs; then
		elisp-compile editors/protobuf-mode.el
	fi
}

multilib_src_compile() {
	if tc-is-cross-compiler; then
		emake -C "${WORKDIR}/build/src" protoc
	fi

	default
}

multilib_src_test() {
	emake check
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
