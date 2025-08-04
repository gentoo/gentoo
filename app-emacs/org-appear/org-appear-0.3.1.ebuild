# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Toggle Org mode element visibility upon entering and leaving"
HOMEPAGE="https://github.com/awth13/org-appear/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/awth13/${PN}.git"
else
	SRC_URI="https://github.com/awth13/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="amd64 ~arm ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

DOCS=( README.org demo.gif )
SITEFILE="50${PN}-gentoo.el"
