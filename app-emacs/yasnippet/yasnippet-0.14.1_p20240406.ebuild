# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp readme.gentoo-r1

DESCRIPTION="Yet another snippet extension for Emacs"
HOMEPAGE="https://joaotavora.github.io/yasnippet/
	https://github.com/joaotavora/yasnippet/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/joaotavora/${PN}.git"
else
	[[ "${PV}" == *p20240406 ]] && COMMIT="e23a80177a9c434174ed8a5955c296d7828a1060"

	SRC_URI="https://github.com/joaotavora/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~sparc ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="doc"

SITEFILE="50${PN}-gentoo-0.13.0.el"

elisp-enable-tests ert -L . -l yasnippet-tests

src_install() {
	elisp-install "${PN}" yasnippet.{el,elc} yasnippet-debug.{el,elc}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	dodoc CONTRIBUTING.md NEWS README.mdown
	use doc && dodoc -r doc/*

	local DOC_CONTENTS="Add the following to your ~/.emacs to use YASnippet:
		\n\t(require 'yasnippet)
		\n\t(yas-global-mode 1)
		\n\nYASnippet no longer bundles snippets directly. Install the package
		app-emacs/yasnippet-snippets for a collection of snippets."
	readme.gentoo_create_doc
}
