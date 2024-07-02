# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="ELisp library that helps keeping Emacs configuration directory clean"
HOMEPAGE="https://github.com/emacscollective/no-littering/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/emacscollective/${PN}.git"
else
	SRC_URI="https://github.com/emacscollective/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	app-emacs/compat
"
BDEPEND="
	${RDEPEND}
"

DOCS=( README.org migrate.org )
SITEFILE="50${PN}-gentoo.el"
