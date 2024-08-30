# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Highlight uncommitted changes, jump between and revert them selectively"
HOMEPAGE="https://github.com/dgutov/diff-hl/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/dgutov/${PN}.git"
else
	SRC_URI="https://github.com/dgutov/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3+"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

BDEPEND="
	test? ( dev-vcs/git )
"

DOCS=( README.md screenshot{,-dired,-margin}.png )
SITEFILE="50${PN}-gentoo.el"

src_test() {
	ebegin "Creating a git repository for tests"
	git init "${S}" --initial-branch="master" &&
		git add "${S}" &&
		git config --local user.email "test@test" &&
		git config --local user.name "test" &&
		git commit --message "test" --quiet
	eend "${?}" || die

	emake EMACS="${EMACS} ${EMACSFLAGS}" test
}
