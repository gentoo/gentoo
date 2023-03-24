# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="24.3"

inherit elisp

DESCRIPTION="Modern on-the-fly syntax checking extension for GNU Emacs"
HOMEPAGE="https://www.flycheck.org/"
COMMIT="5f2ef177cb21ae8b73714575802beef04abd0f5e"
SRC_URI="https://github.com/flycheck/flycheck/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

IUSE="test"
LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=app-emacs/dash-2.12.1
	>=app-emacs/pkg-info-0.4
	test? ( app-emacs/shut-up
			app-emacs/buttercup )"

SITEFILE="50${PN}-gentoo-r1.el"
DOCS=( README.md )
RESTRICT="!test? ( test )"

# Flycheck will skip test cases which require a "checker" or emacs package that is not installed.
src_test() {
	${EMACS} \
		${EMACSFLAGS} \
		-L . \
		--load "${S}"/test/flycheck-test.el \
		--load "${S}"/test/run.el \
		-f 'flycheck-run-tests-main'
}

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}

# Remove unneeded test related files.
src_install() {
	rm flycheck-buttercup.el* flycheck-ert.el* || die
	elisp_src_install
}
