# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
AUTOTOOLS_AUTORECONF=1
AUTOTOOLS_PRUNE_LIBTOOL_FILES=all
JAVA_PKG_IUSE="source"
PYTHON_COMPAT=( python2_7 )
DISTUTILS_OPTIONAL=1

inherit autotools-multilib eutils flag-o-matic toolchain-funcs distutils-r1 java-pkg-opt-2 elisp-common

DESCRIPTION="Google's Protocol Buffers -- an efficient method of encoding structured data"
HOMEPAGE="https://code.google.com/p/protobuf/ https://github.com/google/protobuf/"
SRC_URI="https://github.com/google/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0/9" # subslot = soname major version
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-linux ~arm-linux ~x86-linux ~x64-macos ~x86-macos"
IUSE="emacs examples java python static-libs vim-syntax zlib"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

CDEPEND="emacs? ( virtual/emacs )
	python? ( ${PYTHON_DEPS} )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )"
DEPEND="${CDEPEND}
	java? ( >=virtual/jdk-1.5 )
	python? (
		dev-python/google-apputils[${PYTHON_USEDEP}]
		dev-python/setuptools[${PYTHON_USEDEP}]
	)"
RDEPEND="${CDEPEND}
	java? ( >=virtual/jre-1.5 )"

src_prepare() {
	append-cxxflags -DGOOGLE_PROTOBUF_NO_RTTI

	# breaks Darwin, bug #472514
	[[ ${CHOST} != *-darwin* ]] && epatch "${FILESDIR}"/${PN}-2.3.0-asneeded-2.patch

	# fix build with emacs-24.4 (bug #524100)
	epatch "${FILESDIR}"/${PN}-2.5.0-emacs-24.4.patch
	epatch "${FILESDIR}"/${PN}-2.6.1-protoc-cmdline.patch

	autotools-multilib_src_prepare

	if use python; then
		cd python && distutils-r1_src_prepare
	fi
}

src_configure() {
	local myeconfargs=(
		$(use_with zlib)
	)

	if tc-is-cross-compiler; then
		# The build system wants `protoc` when building, so we need a copy that
		# runs on the host.  This is more hermetic than relying on the version
		# installed in the host being the exact same version.
		mkdir -p "${WORKDIR}"/build || die
		pushd "${WORKDIR}"/build >/dev/null
		ECONF_SOURCE=${S} econf_build "${myeconfargs[@]}"
		myeconfargs+=( --with-protoc="${PWD}"/src/protoc )
		popd >/dev/null
	fi

	autotools-multilib_src_configure
}

multilib_src_compile() {
	default

	if multilib_is_native_abi; then
		if use python; then
			einfo "Compiling Python library ..."
			pushd "${S}"/python >/dev/null
			PROTOC="${BUILD_DIR}"/src/protoc distutils-r1_src_compile
			popd >/dev/null
		fi

		if use java; then
			einfo "Compiling Java library ..."
			pushd "${S}" >/dev/null
			"${BUILD_DIR}"/src/protoc --java_out=java/src/main/java --proto_path=src src/google/protobuf/descriptor.proto
			mkdir java/build
			pushd java/src/main/java >/dev/null
			ejavac -d ../../../build $(find . -name '*.java') || die "java compilation failed"
			popd >/dev/null
			jar cf ${PN}.jar -C java/build . || die "jar failed"
			popd >/dev/null
		fi
	fi
}

src_compile() {
	if tc-is-cross-compiler; then
		emake -C "${WORKDIR}"/build/src protoc
	fi

	autotools-multilib_src_compile

	if use emacs; then
		elisp-compile "${S}"/editors/protobuf-mode.el
	fi
}

src_test() {
	autotools-multilib_src_test check

	if use python; then
		pushd python >/dev/null
		distutils-r1_src_test
		popd >/dev/null
	fi
}

src_install() {
	autotools-multilib_src_install

	dodoc CHANGES.txt CONTRIBUTORS.txt README.md

	if use python; then
		pushd python >/dev/null
		distutils-r1_src_install
		popd >/dev/null
	fi

	if use java; then
		java-pkg_dojar ${PN}.jar
		use source && java-pkg_dosrc java/src/main/java/*
	fi

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins editors/proto.vim
		insinto /usr/share/vim/vimfiles/ftdetect/
		doins "${FILESDIR}"/proto.vim
	fi

	if use emacs; then
		elisp-install ${PN} editors/protobuf-mode.el*
		elisp-site-file-install "${FILESDIR}"/70${PN}-gentoo.el
	fi

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
