# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Create local package repository from installed Emacs Lisp packages"
HOMEPAGE="https://github.com/redguardtoo/elpa-mirror/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/redguardtoo/${PN}.git"
else
	SRC_URI="https://github.com/redguardtoo/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
# Tests require network access.
PROPERTIES="test_network"
RESTRICT="test"

DOCS=( README.org )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	emake EMACS="${EMACS}" test
}
