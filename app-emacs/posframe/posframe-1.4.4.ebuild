# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS="26.1"

inherit elisp

DESCRIPTION="Pop up a frame at point"
HOMEPAGE="https://github.com/tumashu/posframe/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/tumashu/${PN}.git"
else
	SRC_URI="https://github.com/tumashu/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.org snapshots )
SITEFILE="50${PN}-gentoo.el"
