# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Modern on-the-fly syntax checking extension for GNU Emacs"
HOMEPAGE="https://www.flycheck.org/
	https://github.com/flycheck/flycheck/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~alpha ~amd64 ~arm arm64 ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-emacs/buttercup
		app-emacs/shut-up
	)
"

ELISP_REMOVE="
	test/specs/test-documentation.el
	test/specs/test-melpa-package.el
"

SITEFILE="50${PN}-gentoo-r1.el"
DOCS=( CHANGES.rst README.md )

elisp-enable-tests buttercup "${S}"

src_compile() {
	elisp-compile "${PN}.el"
	elisp-make-autoload-file
}

src_install() {
	elisp-install "${PN}" ${PN}.el{,c} "${PN}-autoloads.el"
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	einstalldocs
}
