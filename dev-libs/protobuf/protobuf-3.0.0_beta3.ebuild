# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 python3_3 python3_4 python3_5 )
inherit python-r1 autotools flag-o-matic toolchain-funcs elisp-common multilib-minimal

# If you bump this package, also consider bumping the official language bindings!
# At the current time these are java and python.
MY_PV=${PV/_beta/-beta-}

DESCRIPTION="Google's Protocol Buffers -- an efficient method of encoding structured data"
HOMEPAGE="https://github.com/google/protobuf/ https://developers.google.com/protocol-buffers/"
SRC_URI="https://github.com/google/protobuf/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/10"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sh ~sparc ~x86 ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="emacs examples java python static-libs test vim-syntax zlib"

DEPEND="emacs? ( virtual/emacs )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )
	test? ( dev-cpp/gmock[${MULTILIB_USEDEP}] )"
# This is provided for backwards compatibility due to (likely incorrect) use in consumers.
PDEPEND="java? ( dev-java/protobuf-java )
	python? ( dev-python/protobuf-python[${PYTHON_USEDEP}] )"
S="${WORKDIR}/${PN}-${MY_PV}"
PATCHES=( "${FILESDIR}/${PN}-2.5.0-emacs-24.4.patch"
	"${FILESDIR}/${PN}-2.6.1-protoc-cmdline.patch"
	"${FILESDIR}/${PN}-3.0.0_beta2-disable-local-gmock.patch" )

src_prepare() {
	append-cxxflags -DGOOGLE_PROTOBUF_NO_RTTI
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

src_install() {
	multilib-minimal_src_install

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
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
