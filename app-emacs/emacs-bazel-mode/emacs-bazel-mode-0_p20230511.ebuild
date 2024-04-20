# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1

inherit elisp

DESCRIPTION="Emacs major modes for the Bazel build system support"
HOMEPAGE="https://bazel.build/
	https://github.com/bazelbuild/emacs-bazel-mode/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/bazelbuild/${PN}.git"
else
	[[ ${PV} == *_p20230511 ]] && COMMIT=55cba9bd31c660d9b313a993979f012f35673ba2
	SRC_URI="https://github.com/bazelbuild/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}"/${PN}-${COMMIT}
	KEYWORDS="amd64 ~x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
RESTRICT="test"                 # Tests fail.

DOCS=( CONTRIBUTING.md README.md )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert "${S}" -l test.el

src_compile() {
	elisp-compile bazel.el
	elisp-make-autoload-file
}

src_test() {
	TEST_SRCDIR="." TEST_WORKSPACE="." elisp_src_test
}

src_install() {
	rm test.el || die

	elisp_src_install
}
