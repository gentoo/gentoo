# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Emacs-Lisp refactoring utilities"
HOMEPAGE="https://github.com/mhayashi1120/Emacs-erefactor/"

if [[ ${PV} == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/mhayashi1120/Emacs-${PN}.git"
else
	[[ ${PV} == 0.7.2 ]] && COMMIT=bfe27a1b8c7cac0fe054e76113e941efa3775fe8
	SRC_URI="https://github.com/mhayashi1120/Emacs-${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}"/Emacs-${PN}-${COMMIT}
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

# NOTE: Not "${PN}-test.el". The test file misses "(require '${PN})".
elisp-enable-tests ert "${S}" -l ${PN}.el
