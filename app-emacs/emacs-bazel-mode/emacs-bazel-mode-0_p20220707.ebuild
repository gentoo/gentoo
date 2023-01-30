# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ ${PV} == *_p20220707 ]] && COMMIT=8f7875998f233d248097006df224a33873bbc4f2
NEED_EMACS=27.1

inherit elisp

DESCRIPTION="Emacs major modes for the Bazel build system support"
HOMEPAGE="https://bazel.build/
	https://github.com/bazelbuild/emacs-bazel-mode/"
SRC_URI="https://github.com/bazelbuild/${PN}/archive/${COMMIT}.tar.gz
	-> ${P}.tar.gz"
S="${WORKDIR}"/${PN}-${COMMIT}

LICENSE="Apache-2.0"
KEYWORDS="amd64 ~x86"
SLOT="0"

PATCHES=( "${FILESDIR}"/${PN}-bazel-test--directory.patch )

DOCS=( CONTRIBUTING.md README.md )
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
