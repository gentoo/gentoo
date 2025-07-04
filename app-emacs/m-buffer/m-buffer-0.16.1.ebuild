# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

[[ "${PV}" == 0.16.1 ]] && COMMIT="5e7714835b2289f61dad24c0b5cf98d28fc313b0"

inherit elisp edo

DESCRIPTION="List Oriented Buffer Operations for Emacs"
HOMEPAGE="https://github.com/phillord/m-buffer-el/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/phillord/${PN}-el"
else
	SRC_URI="https://github.com/phillord/${PN}-el/archive/${COMMIT}.tar.gz
		-> ${P}.gh.tar.gz"
	S="${WORKDIR}/${PN}-el-${COMMIT}"

	KEYWORDS="amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? (
		app-emacs/load-relative
	)
"

DOCS=( README.md )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	edo ${EMACS} ${EMACSFLAGS} -L . -L test \
		--load dev/fudge-discover --funcall fudge-discover-run-and-exit-batch
}
