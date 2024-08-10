# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27

inherit elisp

DESCRIPTION="Reformat GNU Emacs buffers stably without moving point"
HOMEPAGE="https://github.com/radian-software/apheleia/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/radian-software/${PN}.git"
else
	SRC_URI="https://github.com/radian-software/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"

DOCS=( README.md CHANGELOG.md )
SITEFILE="50${PN}-gentoo.el"
