# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT=47f43f7d839019cac3ba6559d93b29487ca118cb

inherit edo elisp

DESCRIPTION="Emacs major mode for the Julia programming language"
HOMEPAGE="https://github.com/JuliaEditorSupport/julia-emacs/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/JuliaEditorSupport/julia-emacs.git"
else
	SRC_URI="https://github.com/JuliaEditorSupport/julia-emacs/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/julia-emacs-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

DOCS=( CHANGELOG.md README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	local -a bad_tests=(
		julia--test-end-of-defun-nested-2
	)

	edo ${EMACS} ${EMACSFLAGS} ${BYTECOMPFLAGS} \
		-l ert -l ./julia-mode-tests.el \
		--eval "(ert-run-tests-batch-and-exit '(not ${bad_tests[@]}))"
}

src_install() {
	rm ./julia-mode-tests.el{,c} || die

	elisp_src_install
}
