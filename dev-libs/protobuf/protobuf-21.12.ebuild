# Copyright 2008-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake-multilib elisp-common toolchain-funcs

if [[ "${PV}" == *9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/protocolbuffers/protobuf.git"
	EGIT_SUBMODULES=()
else
	SRC_URI="https://github.com/protocolbuffers/protobuf/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 ~loong ~mips ppc64 ~riscv x86 ~amd64-linux ~x86-linux ~x64-macos"
fi

DESCRIPTION="Google's Protocol Buffers - Extensible mechanism for serializing structured data"
HOMEPAGE="https://protobuf.dev/"

LICENSE="BSD"
SLOT="0/3.$(ver_cut 1-2).0"
IUSE="emacs examples test zlib"
RESTRICT="!test? ( test )"

BDEPEND="emacs? ( app-editors/emacs:* )"
DEPEND="
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )
	test? ( >=dev-cpp/gtest-1.9[${MULTILIB_USEDEP}] )
"
RDEPEND="
	emacs? ( app-editors/emacs:* )
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )
"

PATCHES=(
	"${FILESDIR}/${PN}-23.3-disable-32-bit-tests.patch"
	"${FILESDIR}/${PN}-23.3-static_assert-failure.patch"
)

DOCS=( CONTRIBUTORS.txt README.md )

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
		-Dprotobuf_BUILD_EXAMPLES=$(usex examples)
		-Dprotobuf_WITH_ZLIB=$(usex zlib)
		-Dprotobuf_BUILD_TESTS=$(usex test)
	)
	use test && mycmakeargs+=(-Dprotobuf_USE_EXTERNAL_GTEST=ON)

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
