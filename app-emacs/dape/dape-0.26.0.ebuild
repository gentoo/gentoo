# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="30.1"

inherit elisp

DESCRIPTION="Debug Adapter Protocol for Emacs"
HOMEPAGE="https://github.com/svaante/dape/"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/svaante/${PN}"
else
	SRC_URI="https://github.com/svaante/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"

# Requires debugpy, but we do not package debugpy right now, as well as
# js-debug.  Most tests use only the former.
RESTRICT="test"

# Remove tests.el to skip compilation and failing tests (see above comment).
ELISP_REMOVE="
	${PN}-tests.el
"

DOCS=( README.org CHANGELOG.org )
SITEFILE="50${PN}-gentoo.el"

# elisp-enable-tests ert . -l dape-tests.el

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}

src_install() {
	rm -f dape-tests.el* || die
	elisp_src_install
}
