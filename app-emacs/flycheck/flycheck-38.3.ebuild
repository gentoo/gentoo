# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="28.1"

inherit elisp

DESCRIPTION="Modern on-the-fly syntax checking extension for GNU Emacs"
HOMEPAGE="https://www.flycheck.org/
	https://github.com/flycheck/flycheck/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~sparc ~x86 ~x64-macos"
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
	test/specs/test-checker-api.el
	test/specs/test-checker-extensions.el
	test/specs/test-configuration.el
	test/specs/test-customization.el
	test/specs/test-documentation.el
	test/specs/test-error-display.el
	test/specs/test-gpg.el
	test/specs/test-melpa-package.el
	test/specs/test-related-locations.el
	test/specs/test-util.el
"
SITEFILE="50${PN}-gentoo-r1.el"
DOCS=( CHANGELOG.md README.md )

elisp-enable-tests buttercup ./test/specs/ -l ./flycheck.el -L . -L ./test/specs/

src_prepare() {
	rm -f -r ./test/spec/languages || die
	elisp_src_prepare
}

src_compile() {
	elisp-compile "${PN}.el"
	elisp-make-autoload-file
}

src_install() {
	elisp-install "${PN}" "${PN}.el"{,c} "${PN}-autoloads.el"
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	einstalldocs
}
