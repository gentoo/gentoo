# Copyright 2021-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit edo elisp

DESCRIPTION="Modern on-the-fly syntax checking extension for GNU Emacs"
HOMEPAGE="https://www.flycheck.org/
	https://github.com/flycheck/flycheck/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	if [[ ${PV} == *_p20230305 ]] ; then
		COMMIT=5f2ef177cb21ae8b73714575802beef04abd0f5e
		SRC_URI="https://github.com/${PN}/${PN}/archive/${COMMIT}.tar.gz
			-> ${P}.tar.gz"
		S="${WORKDIR}"/${PN}-${COMMIT}
	else
		SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz
			-> ${P}.tar.gz"
	fi
	KEYWORDS="~alpha amd64 ~arm arm64 ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="test"
# Tests fail for now, need more investigation
RESTRICT="!test? ( test ) test"

RDEPEND="
	>=app-emacs/dash-2.12.1
	>=app-emacs/pkg-info-0.4
"
BDEPEND="
	test? (
		app-emacs/buttercup
		app-emacs/shut-up
	)
"

SITEFILE="50${PN}-gentoo-r1.el"
DOCS=( README.md )

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}

src_test() {
	# Flycheck will skip test cases which require a "checker" or emacs package that is not installed.
	edo ${EMACS} \
		${EMACSFLAGS} \
		-L . \
		--load "${S}"/test/flycheck-test.el \
		--load "${S}"/test/run.el \
		-f 'flycheck-run-tests-main'
}

src_install() {
	# Remove unneeded test related files.
	rm flycheck-buttercup.el* flycheck-ert.el* || die
	elisp_src_install
}
