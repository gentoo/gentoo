# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Emacs extension to increase selected region by semantic units"
HOMEPAGE="https://github.com/magnars/expand-region.el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/magnars/${PN}.el"
else
	SRC_URI="https://github.com/magnars/${PN}.el/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}.el-${PV}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"
