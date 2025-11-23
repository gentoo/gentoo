# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="RPC stack for Emacs Lisp"
HOMEPAGE="https://github.com/kiwanami/emacs-epc/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/kiwanami/emacs-epc.git"
else
	SRC_URI="https://github.com/kiwanami/emacs-epc/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/emacs-${P}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/ctable
	app-emacs/deferred
"
BDEPEND="
	${RDEPEND}
"

DOCS=( readme.md demo img )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert "${S}" -l epc.el -l epcs.el -l test-epc.el
