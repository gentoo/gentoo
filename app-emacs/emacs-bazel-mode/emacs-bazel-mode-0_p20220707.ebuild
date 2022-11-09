# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

H=8f7875998f233d248097006df224a33873bbc4f2
NEED_EMACS=27.1

inherit elisp

DESCRIPTION="Emacs major modes for the Bazel build system support"
HOMEPAGE="https://bazel.build/
	https://github.com/bazelbuild/emacs-bazel-mode/"
SRC_URI="https://github.com/bazelbuild/${PN}/archive/${H}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${H}

LICENSE="Apache-2.0"
KEYWORDS="amd64 ~x86"
SLOT="0"

DOCS=( CONTRIBUTING.md README.md )
PATCHES=( "${FILESDIR}"/${PN}-bazel-test--directory.patch )
SITEFILE="50${PN}-gentoo.el"

src_compile() {
	elisp-compile bazel.el
	elisp-make-autoload-file
}

src_test() {
	${EMACS} ${EMACSFLAGS} ${BYTECOMPFLAGS} \
		-l ./test.el -f ert-run-tests-batch-and-exit || die "Testing failed"
}

src_install() {
	rm test.el || die

	elisp_src_install
}
