# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_4 python3_5 )
inherit autotools elisp-common flag-o-matic python-r1 toolchain-funcs multilib-minimal

# If you bump this package, also consider bumping the official language bindings!
# At the current time these are java and python.
MY_PV=${PV/_beta/-beta-}
MY_PV=${MY_PV/_p/.}

DESCRIPTION="Google's Protocol Buffers -- an efficient method of encoding structured data"
HOMEPAGE="https://github.com/google/protobuf/ https://developers.google.com/protocol-buffers/"
SRC_URI="https://github.com/google/protobuf/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/11"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ia64 ~mips ppc ppc64 ~sh ~sparc x86 ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="emacs examples java python static-libs test vim-syntax zlib"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="
	emacs? ( virtual/emacs )
	python? ( ${PYTHON_DEPS} )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gmock[${MULTILIB_USEDEP}] )"
# This is provided for backwards compatibility due to (likely incorrect) use in consumers.
PDEPEND="
	java? ( dev-java/protobuf-java )
	python? ( dev-python/protobuf-python[${PYTHON_USEDEP}] )"

DOCS=( CHANGES.txt CONTRIBUTORS.txt README.md )

PATCHES=(
	"${FILESDIR}/${PN}-2.6.1-protoc-cmdline.patch"
	"${FILESDIR}/${PN}-3.0.2-disable-local-gmock.patch"
)

S="${WORKDIR}/${PN}-${MY_PV}"
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
		# runs on the host.  This is more hermetic than relying on the version
		# installed in the host being the exact same version.
		mkdir -p "${WORKDIR}"/build || die
		pushd "${WORKDIR}"/build >/dev/null || die
		ECONF_SOURCE=${S} econf_build "${myeconfargs[@]}"
		myeconfargs+=( --with-protoc="${PWD}"/src/protoc )
		popd >/dev/null || die
	fi
	ECONF_SOURCE=${S} econf "${myeconfargs[@]}"
}

multilib_src_compile() {
	if tc-is-cross-compiler; then
		emake -C "${WORKDIR}"/build/src protoc
	fi

	default

	if use emacs; then
		elisp-compile "${S}"/editors/protobuf-mode.el
	fi
}

multilib_src_test() {
	emake check
}

multilib_src_install_all() {
	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins editors/proto.vim
		insinto /usr/share/vim/vimfiles/ftdetect/
		doins "${FILESDIR}/proto.vim"
	fi

	if use emacs; then
		elisp-install "${PN}" editors/protobuf-mode.el*
		elisp-site-file-install "${FILESDIR}/70${PN}-gentoo.el"
	fi

	if use examples; then
		DOCS+=( examples )
		docompress -x /usr/share/doc/"${PF}"/examples
	fi

	einstalldocs
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
