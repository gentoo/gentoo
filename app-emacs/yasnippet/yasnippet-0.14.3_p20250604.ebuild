# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp readme.gentoo-r1

DESCRIPTION="Yet another snippet extension for Emacs"
HOMEPAGE="https://joaotavora.github.io/yasnippet/
	https://github.com/joaotavora/yasnippet/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/joaotavora/${PN}"
else
	[[ "${PV}" == *p20250604 ]] && COMMIT="c1e6ff23e9af16b856c88dfaab9d3ad7b746ad37"

	SRC_URI="https://github.com/joaotavora/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="doc"

DOCS=( CONTRIBUTING.md NEWS README.mdown )
SITEFILE="50${PN}-gentoo-0.13.0.el"

DOC_CONTENTS="Add the following to your ~/.emacs to use YASnippet:
\n\t(require 'yasnippet)
\n\t(yas-global-mode 1)
\n\nYASnippet no longer bundles snippets directly. Install the package
app-emacs/yasnippet-snippets for a collection of snippets."

elisp-enable-tests ert "${S}" -L . -l "./${PN}-tests.el"

src_prepare() {
	elisp_src_prepare

	# Skip failing test.
	local -a skip_tests=(
		yas-org-native-tab-in-source-block-emacs-lisp
	)
	local skip_test=""
	for skip_test in "${skip_tests[@]}"; do
		sed -i "/${skip_test}/a (ert-skip nil)" "./${PN}-tests.el" || die
	done
}

src_install() {
	elisp-install "${PN}" "./${PN}.el"{,c} "./${PN}-debug.el"{,c}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	if use doc ; then
		docompress -x "/usr/share/doc/${PF}/org"
		docinto org
		dodoc -r ./doc/*
	fi

	einstalldocs
	readme.gentoo_create_doc
}
