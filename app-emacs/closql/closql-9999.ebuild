# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

NEED_EMACS=27.1

inherit elisp

DESCRIPTION="Store EIEIO objects using EmacSQL"
HOMEPAGE="https://github.com/magit/closql"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/magit/${PN}.git"
else
	SRC_URI="https://github.com/magit/${PN}/archive/v${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="
	>=app-emacs/compat-30.0.0.0
	>=app-emacs/emacsql-4.0.0
"
BDEPEND="${RDEPEND}"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"
