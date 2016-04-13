# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
JAVA_PKG_IUSE="doc source"
PYTHON_COMPAT=( python{2_7,3_{3,4,5}} )
DISTUTILS_OPTIONAL=1

inherit autotools eutils flag-o-matic toolchain-funcs distutils-r1 java-pkg-2 java-pkg-simple elisp-common multilib-minimal

MY_PV=${PV/_beta2/-beta-2}

DESCRIPTION="Google's Protocol Buffers -- an efficient method of encoding structured data"
HOMEPAGE="https://github.com/google/protobuf/ https://developers.google.com/protocol-buffers/"
SRC_URI="https://github.com/google/protobuf/archive/v${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0/10" # subslot = soname major version
KEYWORDS="~amd64 ~amd64-linux ~arm ~arm-linux ~arm64 ~mips ~ppc64 ~sh ~x64-macos ~x86 ~x86-linux ~x86-macos"
IUSE="emacs examples java nano python static-libs test vim-syntax zlib"

CDEPEND="emacs? ( virtual/emacs )
	python? ( ${PYTHON_DEPS} )
	zlib? ( >=sys-libs/zlib-1.2.8-r1[${MULTILIB_USEDEP}] )"
DEPEND="${CDEPEND}
	java? ( >=virtual/jdk-1.5 )
	python? (
		dev-python/setuptools[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
	)
	test? ( dev-cpp/gmock )"
RDEPEND="${CDEPEND}
	java? ( >=virtual/jre-1.5 )"
S="${WORKDIR}/${PN}-${MY_PV}"
REQUIRED_USE="nano? ( java )"

pkg_setup() {
	if use java; then
		java-pkg-2_pkg_setup
	fi
}

src_prepare() {
	append-cxxflags -DGOOGLE_PROTOBUF_NO_RTTI
	eapply "${FILESDIR}/${PN}-2.5.0-emacs-24.4.patch"
	eapply "${FILESDIR}/${PN}-2.6.1-protoc-cmdline.patch"
	default
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		$(use_enable static-libs)
		$(use_with zlib)
	)

	if tc-is-cross-compiler; then
		# The build system wants `protoc` when building, so we need a copy that
		# runs on the host.  This is more hermetic than relying on the version
		# installed in the host being the exact same version.
		mkdir -p "${WORKDIR}"/build || die
		pushd "${WORKDIR}"/build >/dev/null || die
		ECONF_SOURCE=${S} econf_build "${myeconfargs[@]}"
		myeconfargs+=( --with-protoc="${PWD}/src/protoc" )
		popd >/dev/null || die
	fi

	ECONF_SOURCE=${S} econf
}

multilib_src_compile() {
	if tc-is-cross-compiler; then
		emake -C "${WORKDIR}/build/src" protoc
	fi

	emake

	if use emacs; then
		elisp-compile "${S}"/editors/protobuf-mode.el
	fi
	if multilib_is_native_abi; then
		if use python; then
			einfo "Compiling Python library ..."
			pushd "${S}/python" >/dev/null || die
			PROTOC="${BUILD_DIR}/src/protoc" distutils-r1_src_compile
			popd >/dev/null || die
		fi

		if use java; then
			einfo "Compiling Java library ..."
			pushd "${S}/java" >/dev/null || die
			"${BUILD_DIR}/src/protoc" --java_out=src/main/java -I../src ../src/google/protobuf/descriptor.proto
			JAVA_SRC_DIR="${S}/java/src/main/java"
			java-pkg-simple_src_compile
			popd >/dev/null || die
		fi

		if use nano; then
			einfo "Compiling Java Nano library ..."
			pushd "${S}/javanano" >/dev/null || die
			"${BUILD_DIR}/src/protoc" --java_out=src/main/java -I../src ../src/google/protobuf/descriptor.proto
			JAVA_SRC_DIR="${S}/javanano/src/main/java"
			JAVA_GENTOO_CLASSPATH_EXTRA="${S}/java/src/main/java/"
			JAVA_JAR_FILENAME="${PN}-nano.jar"
			java-pkg-simple_src_compile
			popd >/dev/null || die
		fi

	fi
}

src_test() {
	multilib-minimal_src_test check

	if use python; then
		pushd python >/dev/null || die
		distutils-r1_src_test
		popd >/dev/null || die
	fi
}

src_install() {
	multilib-minimal_src_install

	dodoc CHANGES.txt CONTRIBUTORS.txt README.md

	if use python; then
		pushd python >/dev/null || die
		distutils-r1_src_install
		popd >/dev/null || die
	fi

	JAVA_JAR_FILENAME=
	JAVA_SRC_DIR=
	if use java; then
		JAVA_JAR_FILENAME="${S}/java/${PN}.jar"
		JAVA_SRC_DIR="${S}/java/src/main/java"
	fi
	if use nano; then
		JAVA_JAR_FILENAME="${JAVA_JAR_FILENAME} ${S}/javanano/${PN}-nano.jar"
		JAVA_SRC_DIR="${JAVA_SRC_DIR} ${S}/javanano/src/main/java"
	fi
	if use java || use nano; then
		use java && cp -Rv "${S}/java/target" . || die
		use nano && cp -Rvf "${S}/javanano/target" . # Yup, this might fail. So what?
		java-pkg-simple_src_install
	fi

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
		dodoc -r examples
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
