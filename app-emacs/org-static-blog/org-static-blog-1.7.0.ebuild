# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Static site generator using Emacs's org-mode"
HOMEPAGE="https://github.com/bastibe/org-static-blog/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/bastibe/${PN}"
else
	SRC_URI="https://github.com/bastibe/${PN}/archive/${PV}.tar.gz
		-> ${P}.gh.tar.gz"

	KEYWORDS="amd64 ~arm64 ~x86"
fi

LICENSE="BSD"
SLOT="0"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"
