# Copyright 2008-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib elisp-common toolchain-funcs

ABSEIL_BRANCH="lts_2023_08_02" # NOTE from https://github.com/protocolbuffers/protobuf/blob/main/.gitmodules

ABSEIL_MIN_VER="${ABSEIL_BRANCH//lts_}"
ABSEIL_MIN_VER="${ABSEIL_MIN_VER//_/}"

if [[ "${PV}" == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/protocolbuffers/protobuf.git"
	EGIT_SUBMODULES=( '-*' )
	MY_SLOT="27.2"

	inherit git-r3
else
	SRC_URI="https://github.com/protocolbuffers/protobuf/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~mips ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
	MY_SLOT=$(ver_cut 1-2)
fi

DESCRIPTION="Google's Protocol Buffers - Extensible mechanism for serializing structured data"
HOMEPAGE="https://protobuf.dev/"

LICENSE="BSD"
SLOT="0/${MY_SLOT}.0"
IUSE="conformance emacs examples +libprotoc libupb +protobuf +protoc test zlib"

REQUIRED_USE="
	|| (
		libprotoc
		libupb
		protobuf
		protoc
	)
"

RESTRICT="!test? ( test )"

BDEPEND="
	emacs? ( app-editors/emacs:* )
	!protobuf? (
		>=dev-libs/protobuf-${PV}
	)
"

COMMON_DEPEND="
	dev-libs/jsoncpp
	>=dev-cpp/abseil-cpp-${ABSEIL_MIN_VER}:=[${MULTILIB_USEDEP}]
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )
"

DEPEND="
	${COMMON_DEPEND}
	test? ( >=dev-cpp/gtest-1.9[${MULTILIB_USEDEP}] )
"
RDEPEND="
	${COMMON_DEPEND}
	${BDEPEND}
"

PATCHES=(
	"${FILESDIR}/${PN}-26.1-disable-32-bit-tests.patch"
	"${FILESDIR}/${PN}-23.3-static_assert-failure.patch"
)

DOCS=( CONTRIBUTORS.txt README.md )

# src_prepare() {
# 	rm "${S}/third_party/utf8_range/" -rf || die
# 	cmake_src_prepare
# }

src_configure() {
	if tc-ld-is-gold; then
		# https://sourceware.org/bugzilla/show_bug.cgi?id=24527
		tc-ld-disable-gold
	fi

	cmake-multilib_src_configure
}

multilib_src_configure() {
	local mycmakeargs=(
		-Dprotobuf_ABSL_PROVIDER="package"
		-Dprotobuf_JSONCPP_PROVIDER="package"

		-Dprotobuf_BUILD_CONFORMANCE="$(usex test "$(usex conformance)")"
		-Dprotobuf_BUILD_EXAMPLES="$(usex examples)"
		-Dprotobuf_BUILD_LIBPROTOC="$(usex libprotoc)"
		-Dprotobuf_BUILD_LIBUPB="$(usex libupb)"
		-Dprotobuf_BUILD_PROTOBUF_BINARIES="$(usex protobuf)"
		-Dprotobuf_BUILD_PROTOC_BINARIES="$(usex protoc)"
		-Dprotobuf_BUILD_SHARED_LIBS="yes"
		-Dprotobuf_BUILD_TESTS="$(usex test)"

		-Dprotobuf_DISABLE_RTTI="no"

		-Dprotobuf_INSTALL="yes"
		-Dprotobuf_INSTALL_EXAMPLES="$(usex examples)"
		-Dprotobuf_TEST_XML_OUTDIR="$(usex test)"

		-Dprotobuf_WITH_ZLIB="$(usex zlib)"
		-Dprotobuf_VERBOSE="yes"
	)
	use test && mycmakeargs+=( -Dprotobuf_USE_EXTERNAL_GTEST="yes" )

	cmake_src_configure
}

src_compile() {
	cmake-multilib_src_compile

	if use emacs; then
		elisp-compile editors/protobuf-mode.el
	fi
}

src_test() {
	local -x srcdir="${S}"/src
	cmake-multilib_src_test
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
		elisp-install "${PN}" editors/protobuf-mode.el*
		elisp-site-file-install "${FILESDIR}/70${PN}-gentoo.el"
	fi

	if use examples; then
		DOCS+=(examples)
		docompress -x "/usr/share/doc/${PF}/examples"
	fi

	einstalldocs
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
