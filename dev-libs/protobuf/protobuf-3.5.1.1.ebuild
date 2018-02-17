# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools elisp-common flag-o-matic multilib-minimal toolchain-funcs

DESCRIPTION="Google's Protocol Buffers - Extensible mechanism for serializing structured data"
HOMEPAGE="https://developers.google.com/protocol-buffers/ https://github.com/google/protobuf"
SRC_URI="https://github.com/google/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/15"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh sparc x86 ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="emacs examples static-libs test zlib"

RDEPEND="emacs? ( virtual/emacs )
	zlib? ( sys-libs/zlib[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	test? ( >=dev-cpp/gtest-1.8.0[${MULTILIB_USEDEP}] )"

PATCHES=(
	"${FILESDIR}/${PN}-3.4.0-disable_no-warning-test.patch"
	"${FILESDIR}/${PN}-3.4.0-system_libraries.patch"
	"${FILESDIR}/${PN}-3.4.0-protoc_input_output_files.patch"
)

DOCS=(CHANGES.txt CONTRIBUTORS.txt README.md)

src_prepare() {
	append-cppflags -DGOOGLE_PROTOBUF_NO_RTTI
	default
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_with zlib)
	)

	if tc-is-cross-compiler; then
		# The build system wants `protoc` when building, so we need a copy that
		# runs on the host. This is more hermetic than relying on the version
		# installed in the host being the exact same version.
		mkdir -p "${WORKDIR}/build" || die
		pushd "${WORKDIR}/build" > /dev/null || die
		ECONF_SOURCE="${S}" econf_build "${myeconfargs[@]}"
		myeconfargs+=(--with-protoc="${PWD}"/src/protoc)
		popd > /dev/null || die
	fi

	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
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
