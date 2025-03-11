# Copyright 2023-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="29.1"

inherit elisp

DESCRIPTION="Debug Adapter Protocol for Emacs"
HOMEPAGE="https://github.com/svaante/dape"

if [[ "${PV}" == 9999 ]]; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/svaante/${PN}.git"
else
	SRC_URI="https://github.com/svaante/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	|| (
		app-emacs/jsonrpc
		>=app-editors/emacs-30:*
	)
"
DEPEND="
	${RDEPEND}
"

# Requires debugpy, but we do not package debugpy right now, as well as
# js-debug.  Most tests use only the former.
RESTRICT="test"

# Remove tests.el to skip compilation and failing tests (see above comment).
ELISP_REMOVE="${PN}-tests.el"

DOCS=( README.org CHANGELOG.org LICENSE )
SITEFILE="50${PN}-gentoo.el"

# elisp-enable-tests ert . -l dape-tests.el

pkg_setup() {
	elisp_pkg_setup
	local has_jsonrpc="$(${EMACS} ${EMACSFLAGS} \
		--eval "(princ (>= emacs-major-version 30))")"
	if has_version app-emacs/jsonrpc || [[ ${has_jsonrpc} = t ]]; then
		:
	else
		die "Emacs does not have jsonrpc.el 1.0.25 or later, nor was app-emacs/jsonrpc installed"
	fi
}

src_compile() {
	elisp_src_compile
	elisp-make-autoload-file
}

src_install() {
	# Need to ignore dape-tests.el.
	einstalldocs
	elisp-install "${PN}" dape.el dape.elc dape-autoloads.el
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
}
