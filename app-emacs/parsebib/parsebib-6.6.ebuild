# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Emacs Lisp library for reading .bib files"
HOMEPAGE="https://github.com/joostkremers/parsebib/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/joostkremers/${PN}.git"
else
	SRC_URI="https://github.com/joostkremers/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert-runner test
