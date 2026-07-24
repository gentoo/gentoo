# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

NEED_EMACS="28.1"

inherit elisp

DESCRIPTION="Emacs web feeds client"
HOMEPAGE="https://github.com/emacs-elfeed/elfeed/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/emacs-${PN}/${PN}"
else
	SRC_URI="https://github.com/emacs-${PN}/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="Unlicense"
SLOT="0"

RDEPEND="
	net-misc/curl[ssl]
	>=app-emacs/compat-31.0.0.1
"
BDEPEND="
	${RDEPEND}
"

DOCS=( NEWS.org README.org )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert ./tests/ -l ./tests/elfeed-tests.el
