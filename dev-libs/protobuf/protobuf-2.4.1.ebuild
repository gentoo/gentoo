# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"

JAVA_PKG_IUSE="source"
PYTHON_DEPEND="python? 2"
DISTUTILS_SRC_TEST="setup.py"

inherit autotools eutils distutils java-pkg-opt-2 elisp-common

DESCRIPTION="Google's Protocol Buffers -- an efficient method of encoding structured data"
HOMEPAGE="http://code.google.com/p/protobuf/"
SRC_URI="http://protobuf.googlecode.com/files/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm -hppa ~ia64 ~mips ppc ppc64 x86 ~amd64-linux ~arm-linux ~x86-linux ~x64-macos"
IUSE="emacs examples java python static-libs vim-syntax"

DEPEND="${DEPEND} java? ( >=virtual/jdk-1.5 )
	python? ( dev-python/setuptools )
	emacs? ( virtual/emacs )"
RDEPEND="${RDEPEND} java? ( >=virtual/jre-1.5 )
	emacs? ( virtual/emacs )"

DISTUTILS_SETUP_FILES=("python|setup.py")
PYTHON_MODNAME="google/protobuf"

pkg_setup() {
	if use python; then
		python_set_active_version 2
		python_pkg_setup
	fi
	use java && java-pkg-opt-2_pkg_setup
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.3.0-asneeded-2.patch
	eautoreconf

	if use python; then
		python_convert_shebangs -r 2 .
		distutils_src_prepare
	fi
}

src_configure() {
	econf \
		$(use_enable static-libs static)
}

src_compile() {
	emake || die "emake failed"

	if use python; then
		einfo "Compiling Python library ..."
		distutils_src_compile
	fi

	if use java; then
		einfo "Compiling Java library ..."
		src/protoc --java_out=java/src/main/java --proto_path=src src/google/protobuf/descriptor.proto
		mkdir java/build
		pushd java/src/main/java
		ejavac -d ../../../build $(find . -name '*.java') || die "java compilation failed"
		popd
		jar cf "${PN}.jar" -C java/build . || die "jar failed"
	fi

	if use emacs; then
		elisp-compile "${S}/editors/protobuf-mode.el" || die "elisp-compile failed!"
	fi
}

src_test() {
	emake check || die "emake check failed"

	if use python; then
		 distutils_src_test
	fi
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc CHANGES.txt CONTRIBUTORS.txt README.txt

	use static-libs || rm -rf "${D}"/usr/lib*/*.la

	if use python; then
		distutils_src_install
	fi

	if use java; then
		java-pkg_dojar ${PN}.jar
		use source && java-pkg_dosrc java/src/main/java/*
	fi

	if use vim-syntax; then
		insinto /usr/share/vim/vimfiles/syntax
		doins editors/proto.vim
		insinto /usr/share/vim/vimfiles/ftdetect/
		doins "${FILESDIR}/proto.vim"
	fi

	if use emacs; then
		elisp-install ${PN} editors/protobuf-mode.el* || die "elisp-install failed!"
		elisp-site-file-install "${FILESDIR}/70${PN}-gentoo.el"
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}/examples
		doins -r examples/* || die "doins examples failed"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
	use python && distutils_pkg_postinst
}

pkg_postrm() {
	use emacs && elisp-site-regen
	use python && distutils_pkg_postrm
}
