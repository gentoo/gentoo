# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Provide extra news client subscription protocols for elfeed"
HOMEPAGE="https://github.com/fasheng/elfeed-protocol/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/fasheng/${PN}.git"
else
	SRC_URI="https://github.com/fasheng/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

RDEPEND="app-emacs/elfeed"
BDEPEND="${RDEPEND}"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

elisp-enable-tests ert-runner test
